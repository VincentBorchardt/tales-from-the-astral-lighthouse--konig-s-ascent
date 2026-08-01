extends Node2D

signal player_entered
signal warp_in_finished
signal warp_out_finished

@onready var booth_area = $Area2D
@onready var animations = $Animations
@onready var interaction_animation = $InteractAnimation
@onready var interaction_range = $InteractionRange
@onready var exit_sfx = $Exit
@onready var enter_sfx = $Enter

var end_of_level = false

func _ready() -> void:
	visible = true
	booth_area.monitoring = false
	warp_in()

func warp_in():
	enter_sfx.play()
	animations.play("warp_in")

func warp_out():
	interaction_animation.visible = false
	exit_sfx.play()
	animations.play("warp_out")

func stay_open():
	$Area2D.visible = true
	animations.play("open")
	booth_area.monitoring = true
	interaction_range.monitoring = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	emit_signal("player_entered")
	#transition to next gameplay area


func _on_animations_animation_finished() -> void:
	match animations.animation:
		"warp_in":
			warp_in_finished.emit()
		"warp_out":
			warp_out_finished.emit()
		_:
			pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal("player_entered")


func _on_interaction_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and GameplayManager.end_of_level == true:
		interaction_animation.visible = true
		interaction_animation.play("interaction")


func _on_interaction_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		interaction_animation.visible = false
