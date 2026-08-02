extends Node2D

@onready var door_animation = $Door
@onready var dsd_spawn = $DsdSpawn
@onready var hit_sound = $Hit
@onready var door_cover = $DoorCover
@onready var door_hit = $DoorHit
@onready var hit_timer = $HitTimer
@export var packedShippieDue : PackedScene

var health := 3:
	set(value):
		health = value

		if health <= 0:
			open_door()

func _ready():
	GameplayManager.shippie_door.connect(show_glimmer)

func show_glimmer():
	visible = true
	door_animation.visible = true
	door_animation.play("glimmer")

func open_door():
	door_animation.play("opened")
	door_cover.visible = true
	var shippie = packedShippieDue.instantiate()
	get_tree().current_scene.add_child(shippie)
	shippie.global_position = dsd_spawn.global_position

func _on_area_2d_area_entered(area: Area2D) -> void:
	hit_sound.play()
	health -= 1
	if health <= 0:
		return
	door_hit.visible = true
	hit_timer.start()


func _on_hit_timer_timeout() -> void:
	door_hit.visible = false
