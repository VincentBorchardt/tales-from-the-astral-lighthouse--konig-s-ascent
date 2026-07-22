extends Node2D

@export var waves: Array[PackedScene]
@export var booth_scene: PackedScene

@onready var booth_spawn = $BoothSpawn
@onready var wave_timer = $WaveTimer

var current_wave := -1
var current_wave_scene: Node2D
var enemies_remaining := 0


func _ready():
	wave_timer.one_shot = true
	wave_timer.timeout.connect(start_next_wave)

	start_next_wave()

#TODO: set everything here that needs to be at the start of a round or when all waves or finished
func start_next_wave():
	current_wave += 1

	#TODO: this is where end of round stuff happens
	if current_wave >= waves.size():
		print("all waves complete")
		var booth = booth_scene.instantiate()
		booth.global_position = booth_spawn.global_position
		add_child(booth)
		return

	current_wave_scene = waves[current_wave].instantiate()
	add_child(current_wave_scene)

	enemies_remaining = current_wave_scene.enemy_count

	print("new wave")


func enemy_spawned(enemy):
	enemy.died.connect(enemy_died)


func enemy_died():
	enemies_remaining -= 1
	print("enemies remaining:", enemies_remaining)

	if enemies_remaining <= 0:
		wave_complete()


func wave_complete():
	print("wave complete")
	current_wave_scene.queue_free()
	
	wave_timer.start()
