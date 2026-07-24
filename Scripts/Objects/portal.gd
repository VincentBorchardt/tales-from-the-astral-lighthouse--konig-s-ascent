extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_delay := 5.0
@export var appear_delay := 5.0
@onready var spawn_timer = $SpawnTimer
@onready var Appear_timer = $AppearTimer
@onready var portal_anim = $AnimatedSprite2D

func _ready():
	visible = false
	Appear_timer.wait_time = appear_delay
	Appear_timer.one_shot = true
	Appear_timer.timeout.connect(update_visibility)
	Appear_timer.start()
	

func update_visibility():
	visible = true
	portal_anim.play("portal")


func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = global_position
	get_parent().add_child(enemy)
	get_tree().current_scene.enemy_spawned(enemy)
	queue_free()
