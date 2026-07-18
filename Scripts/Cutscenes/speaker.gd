class_name Speaker extends Resource

# TODO find a way to make this a class both NPCs and the player can inherit from?
# In particular, we could put the sprite in here to make it easier to place characters

@export_group("")
@export var name: String


@export_group("Images")
@export var full_picture_left: Texture2D
@export var full_picture_right: Texture2D
