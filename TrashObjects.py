import pygame
from Constants import PATH
from TrashTypes import TrashType

class Trash(pygame.sprite.Sprite):
    # Class-level dictionary to store loaded images
    trash_sprites = {}

    def __init__(self, trash_type, speed=99, scale=3) -> None:
        super().__init__()
        self.speed = speed
        self.scale = scale
        self.type = trash_type

        # Load the image based on the trash type
        if self.type in Trash.trash_sprites:
            self.image = Trash.trash_sprites[self.type]
        else:
            raise ValueError(f"Invalid trash type: {self.type}")

        self._scale_image()

        self.rect = self.image.get_rect()

    @classmethod
    # ClassMethod is like static but can access self attributes
    def load_sprites(cls):
        # Load images and store them in the dictionary
        cls.trash_sprites[TrashType.BIO] = pygame.image.load(PATH + "Assets/Sprites/Apple.png").convert_alpha()
        cls.trash_sprites[TrashType.PLASTIC] = pygame.image.load(PATH + "Assets/Sprites/Plasticbottle.png").convert_alpha()
        cls.trash_sprites[TrashType.ALUMINIUM] = pygame.image.load(PATH + "Assets/Sprites/trashcan.png").convert_alpha()
        cls.trash_sprites[TrashType.PAPER] = pygame.image.load(PATH + "Assets/Sprites/paper.png").convert_alpha()
    def _scale_image(self):
        # Scale the image
        self.image = pygame.transform.scale(self.image, (int(self.image.get_width() * self.scale), int(self.image.get_height() * self.scale)))

    def update(self, dt, group, block_height) -> None:
        collided = any(self.rect.colliderect(block.rect) for block in group if self != block)
        if not collided and self.rect.topleft[1] < block_height*0.7:
            self.rect.move_ip(0, self.speed * dt)



class PlasticTrash(Trash):
    def __init__(self, x=0, y=0, points=10) -> None:
        super().__init__(TrashType.PLASTIC)
        self.points = points

        self.rect.center = (x, y)
    

class AluminiumTrash(Trash):
    def __init__(self, x=0, y=0, points=10) -> None:
        super().__init__(TrashType.ALUMINIUM)
        self.points = points

        self.rect.center = (x, y)
    
class BioTrash(Trash):
    def __init__(self, x=0, y=0, points=10) -> None:
        super().__init__(TrashType.BIO)
        self.points = points

        self.rect.center = (x, y)

class PaperTrash(Trash):
    def __init__(self, x=0, y=0, points=10) -> None:
        super().__init__(TrashType.PAPER)
        self.points = points

        self.rect.center = (x, y)
