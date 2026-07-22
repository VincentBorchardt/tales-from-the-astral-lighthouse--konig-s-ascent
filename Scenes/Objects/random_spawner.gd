extends Node2D

@export var portal_scene: PackedScene
@export var maxEnemies = 12
@onready var spawn_check = $SpawnCheck
@onready var timer = $EnemySpawnTimer
@onready var spawn_Area = $CollisionShape2D.shape.extents
@onready var origin = $CollisionShape2D.global_position -  spawn_Area

func spawn_portal():
	for attempt in 50:

		var pos = Vector2(
			randf_range(origin.x, spawn_Area.x),
			randf_range(origin.y, spawn_Area.y)
		)

		spawn_check.global_position = pos

		await get_tree().physics_frame

		if spawn_check.get_overlapping_bodies().is_empty():
			create_portal(pos)
			return


func create_portal(pos: Vector2):
	var portal = portal_scene.instantiate()
	portal.global_position = pos
	get_parent().add_child(portal)
