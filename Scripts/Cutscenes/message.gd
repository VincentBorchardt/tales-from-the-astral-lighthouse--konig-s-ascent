class_name Message extends Resource

@export var speaker : Speaker
@export_multiline var message : String
#@export var alt_picture : Texture2D
@export var image_location : Location
@export var has_box : bool = true
@export var animation_time: float = 2.5
@export var color: Color

@export var choices: bool
@export var yes_scene: PackedScene
@export var no_scene: PackedScene
enum Location {LEFT, RIGHT}
