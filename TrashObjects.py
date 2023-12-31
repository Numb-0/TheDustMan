import pygame
from TrashTypes import TrashType

IMAGE_SIZE = (200, 200)

class Trash():
    def __init__(self, points = 5, speed = 100) -> None:
        self.points = points
        self.speed = speed

    # Remember to use at least once after importing
    @staticmethod
    def load_sprites():
        # I made it global so that it stays in memory once
        # i inserted it here to make it more clear
        # i dont think it is a problem?
        global PLASTIC_SPRITE
        PLASTIC_SPRITE = pygame.image.load("apple.png").convert_alpha()


class PlasticTrash(Trash, pygame.sprite.Sprite):
    def __init__(self, x, y) -> None:
        # Trash itinerance
        Trash.__init__(self, 20)
        self.type = TrashType.PLASTIC

        # Sprite itinerance
        pygame.sprite.Sprite.__init__(self)
        self.image = PLASTIC_SPRITE
        self.image = pygame.transform.scale(self.image, IMAGE_SIZE)
        self.rect = self.image.get_rect()
        self.rect.topleft = (x, y)
    
    def update(self, dt):
        #self.rect.move_ip(0, self.speed * dt)
        pass
