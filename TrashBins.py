import pygame
from TrashTypes import TrashType

# TrashBin classes

class TrashBin:
    def __init__(self, trash_type) -> None:
        self.type = trash_type
    
    def is_acceptable_trash(self, trash):
        if trash.type in self.type:
            return True
        return False

class ContenitorsTrashBin(TrashBin):
    def __init__(self) -> None:
        super().__init__(TrashType.CONTENITORS)

class BioTrashBin(TrashBin):
    def __init__(self) -> None:
        super().__init__(TrashType.BIO)

class PaperTrashBin(TrashBin):
    def __init__(self) -> None:
        super().__init__(TrashType.PAPER)
