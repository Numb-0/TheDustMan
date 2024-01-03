import pygame
# Importing all costants
from Constants import *
from GameLogic import SceneManager

pygame.init()
# Setting screen sizes
screen = pygame.display.set_mode((400, 400), pygame.SCALED | pygame.FULLSCREEN)
scene_manager = SceneManager(screen)

# Game bools
game_running = True
while game_running:
    scene_manager.handle_inputs(pygame.event.get())

pygame.quit()