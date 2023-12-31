import pygame
from TrashTypes import TrashType

# TrashBin classes

class TrashBin:
    def __init__(self, trash_type) -> None:
        self.type = trash_type

class ContenitorsTrashBin(TrashBin):
    def __init__(self) -> None:
        super().__init__(TrashType.CONTENITORS)
