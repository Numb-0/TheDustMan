import pygame
from TrashObjects import IMAGE_SIZE, PlasticTrash, Trash

pygame.init()

# Setting screen sizes
screen_info = pygame.display.Info() 
Height = screen_info.current_h
Width = screen_info.current_w
screen = pygame.display.set_mode((Width, Height-400))

# Loading sprites
# Remember to unpack tuple using *
TRASH_INIT_POSITION = (int((Width-IMAGE_SIZE[0])/2),int(0))
Trash.load_sprites()

# Setting FPS limit
FPS = 60
clock = pygame.time.Clock()

# Creating some gameobject
trash_group = pygame.sprite.Group()

trash1 = PlasticTrash(*TRASH_INIT_POSITION)
trash_group.add(trash1)

running = True

timer_clock = pygame.time.Clock()
dt_timer = 0
click_counter = 0
counting_clicks = False
TIMER_LIMIT = 0.5

while running:
    dt = clock.tick(FPS) / 1000
    print(clock.get_fps())
    # checking for events
    dt_timer += timer_clock.tick() /1000

    for event in pygame.event.get():
        # if clicking close window
        if event.type == pygame.QUIT:
            # exiting loop and executing quit()
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if not counting_clicks:
                counting_clicks =  True
                click_counter = 1
                dt_timer = 0
            elif (dt_timer < TIMER_LIMIT):
                click_counter +=1
    if (dt_timer >= TIMER_LIMIT and counting_clicks):        
        if (click_counter >= 3):
            trash1.rect.move_ip(300, 0)
        elif (click_counter == 2):
            trash1.rect.move_ip(0, -100) 
        elif (click_counter == 1):
            trash1.rect.move_ip(-300, 0)
        counting_clicks = False
    
    # Refreshing screen to clean last frame
    screen.fill("purple")

    trash_group.update(dt)
    trash_group.draw(screen)
    # print(trash_group)

    # RENDER YOUR GAME HERE

    # flip() the display to put your work on screen
    pygame.display.flip()

pygame.quit()