from enum import Flag, auto

# Creating trash types and combinations

class TrashType(Flag):
    # we try to define the more basic types
    PLASTIC = auto()
    BIO = auto()
    GLASS = auto()
    PAPER = auto()
    ALUMINIUM = auto()

    # we can also create a combination of them
    CONTENITORS = PLASTIC | ALUMINIUM | GLASS
