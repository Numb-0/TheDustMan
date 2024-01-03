import pygame
from Button import Button
from Constants import *
from TrashObjects import *
from TrashTypes import TrashType
import random
import json

class UiManager():
    button_sprites = {}
    
    def __init__(self, screen) -> None:
        self.screen = screen
        self.font = pygame.font.SysFont("arialblack", 20)
        self.font_color = (255,255,255)
        self.collected_points = 0

        # creating the buttons
        self.pause_button = Button(SceneManager.WIDTH/2 - UiManager.button_sprites["pause_button"].get_width()/2, SceneManager.HEIGHT/2, UiManager.button_sprites["pause_button"], 1)
        self.quit_button = Button(SceneManager.WIDTH/2 - UiManager.button_sprites["quit_button"].get_width()/2, SceneManager.HEIGHT/1.5, UiManager.button_sprites["quit_button"], 1)
        self.start_button = Button(SceneManager.WIDTH/2 - UiManager.button_sprites["start_button"].get_width()/2, SceneManager.HEIGHT/1.5, UiManager.button_sprites["start_button"], 1)
    
    def draw_text(self, text, x, y) -> None:
        img = self.font.render(text, True, self.font_color)
        self.screen.blit(img, (x, y))

    @classmethod
    def load_sprites(cls):
        cls.button_sprites["pause_button"] = pygame.image.load(PATH + "Assets/Buttons/PauseButton.svg").convert_alpha()
        cls.button_sprites["quit_button"] = pygame.image.load(PATH + "Assets/Buttons/QuitButton.svg").convert_alpha()
        cls.button_sprites["start_button"] = pygame.image.load(PATH + "Assets/Buttons/StartButton.svg").convert_alpha()
    

class ObjectManager():
    
    def __init__(self) -> None:
        self.live_trash_group = pygame.sprite.Group() 
        self.trash_types = list(TrashType)

    def create_trash(self, type, x, y):
        if (type == TrashType.PLASTIC):
            return PlasticTrash(x, y)
        elif (type == TrashType.ALUMINIUM):
            return AluminiumTrash(x, y)
        elif (type == TrashType.BIO):
            return BioTrash(x, y)
        elif (type == TrashType.PAPER):
            return PaperTrash(x, y)
        else:
            return AluminiumTrash(x, y)
    
    def create_random_object(self, x, y):
        # Create object and append it to the list
        return self.live_trash_group.add(self.create_trash(random.choice(self.trash_types), x , y))
    
    def destroy_first_object(self):
        if self.live_trash_group.sprites():
            self.live_trash_group.sprites()[0].kill()


class GameManager:
    clock = pygame.time.Clock()
    
    def __init__(self, screen) -> None:
        self.uimanager = UiManager(screen)
        self.screen = screen
        self.objectmanager = ObjectManager()

        self.game_paused = False
        self.click_counter = 0
        self.counting_clicks = False
        self.dt_timer = 0

        # Player Ui
        self.player_score = 0
        self.player_lives = 3
        self.is_game_over = False
        self.game_start = False
        self.best_score = 0

        self.game_data = {
            "best_score" : 0 
        }
        #self.load_data()

        # rect to choose wehn to spawn new item
        self.mock_object = PaperTrash(SceneManager.WIDTH/2, -100)

    def handle_inputs(self, events):
        dt = GameManager.clock.tick(FPS) / 1000
        if self.counting_clicks:
            self.dt_timer += dt
        
        if not self.game_start:
            self.screen.fill((128, 0, 128))
            if(self.uimanager.start_button.draw(self.screen)):
                self.game_start = True
                pygame.time.wait(1500)
                return
            self.uimanager.draw_text("Your Best score is" + str(self.game_data["best_score"]), SceneManager.WIDTH/2, 0)
        if not self.game_paused and self.game_start:
            # check the objects
            if len(self.objectmanager.live_trash_group.sprites()) <= 6:
                if not pygame.sprite.spritecollide(self.mock_object, self.objectmanager.live_trash_group, False):
                    self.objectmanager.create_random_object(SceneManager.WIDTH/2, -100)

            for event in events:
                if event.type == pygame.QUIT:
                    self.save_data()
                    pygame.quit()
                    exit()
                # Start counting clicks
                if event.type == pygame.MOUSEBUTTONDOWN:
                    if not self.counting_clicks:
                        self.counting_clicks = True
                        self.click_counter = 1
                        self.dt_timer = 0
                    elif self.dt_timer < TIMER_LIMIT:
                        self.click_counter += 1
                # Check keys
                if event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_SPACE:
                        self.game_paused = not self.game_paused
                    # test
                    if event.key == pygame.K_l:
                        print("pressed l")
                        #self.objectmanager.create_random_object(*pygame.mouse.get_pos())
                    if event.key == pygame.K_d:
                        print("pressed d")
                        self.objectmanager.destroy_first_object()

            # Check how many times clicked
            if self.dt_timer >= TIMER_LIMIT and self.counting_clicks:
                if self.objectmanager.live_trash_group.sprites():
                    first_item_rect = self.objectmanager.live_trash_group.sprites()[0].rect
                    if self.click_counter >= 3:
                        first_item_rect.move_ip(100, 0)
                    elif self.click_counter == 2:
                        first_item_rect.move_ip(-100, 0)
                    elif self.click_counter == 1:
                        first_item_rect.move_ip(0, 100)
                self.counting_clicks = False
            
            
            # DRAW HERE
            # Game + Ui
            self.screen.fill((128, 0, 128))  # Purple color
            self.objectmanager.live_trash_group.update(dt, self.objectmanager.live_trash_group, SceneManager.HEIGHT)
            self.objectmanager.live_trash_group.draw(self.screen)
            self.uimanager.draw_text(str(self.player_score), 0, 0)
            self.uimanager.draw_text(str(self.player_lives), SceneManager.WIDTH*0.95, 0)

        # Pause menu
        elif self.game_paused:
            # Draw pause menu and check for other events
            for event in events:
                if event.type == pygame.QUIT:
                    pygame.quit()
                    exit()
            if self.uimanager.pause_button.draw(self.screen):
                self.game_paused = False
            if self.uimanager.quit_button.draw(self.screen):
                self.save_data()
                pygame.quit()
                exit()
        
        # flip() the display to put your work on screen
        pygame.display.flip()
    
    def save_data(self):
        with open("save.txt", "w") as save_file:
            json.dump(self.game_data, save_file)

    def load_data(self):
        with open("save.txt", "rb") as save_file:
            self.game_data = json.load(save_file)
        

class SceneManager():
    def __init__(self, screen) -> None:
        self.load_all_sprites()
        SceneManager.WIDTH = screen.get_width()
        SceneManager.HEIGHT = screen.get_height()
        self.gm = GameManager(screen)

    def handle_inputs(self, events) -> None:
        self.gm.handle_inputs(events)

    def load_all_sprites(self):
        Trash.load_sprites()
        UiManager.load_sprites()

