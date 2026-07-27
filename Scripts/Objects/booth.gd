extends Node2D

signal player_entered
signal warp_in_finished
signal warp_out_finished

@onready var animations = $Animations

func _ready() -> void:
	visible = true
	warp_in()

func warp_in():
	animations.play("warp_in")

func warp_out():
	animations.play("warp_out")

func stay_open():
	$Area2D.visible = true
	animations.play("open")

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
