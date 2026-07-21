extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_delay := 5
@export var appear_delay := 5
@onready var spawn_timer = $SpawnTimer
@onready var Appear_timer = $AppearTimer

func _ready():
	visible = false
	Appear_timer.wait_time = appear_delay
	Appear_timer.one_shot = true
	Appear_timer.timeout.connect(update_visibility)
	Appear_timer.start()
	

func update_visibility():
	visible = true
	spawn_timer.wait_time = spawn_delay
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(spawn_enemy)
	spawn_timer.start()
	

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = global_position
	get_parent().add_child(enemy)
	queue_free()
