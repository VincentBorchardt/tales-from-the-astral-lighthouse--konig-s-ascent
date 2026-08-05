extends Node

const SILENT_VOLUME_DB := -40.0
const DEFAULT_VOLUME_DB := 0.0

var music_audio_player_count : int = 2
var current_music_player : int = 0
var music_players : Array[ AudioStreamPlayer ] = []
var music_bus : String = "Music"

var music_fade_duration : float = 0.5


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in music_audio_player_count:
		var player = AudioStreamPlayer.new()
		add_child( player )
		player.bus = music_bus
		music_players.append( player )
		player.volume_db = 0


func play_music(_audio: AudioStream) -> void:
	if _audio == null:
		return

	var old_player := music_players[current_music_player]
	var position := old_player.get_playback_position()

	current_music_player = (current_music_player + 1) % music_audio_player_count

	var new_player := music_players[current_music_player]

	new_player.stream = _audio
	new_player.volume_db = SILENT_VOLUME_DB
	new_player.play(position)

	var fade_in := create_tween()
	fade_in.tween_property(
		new_player,
		"volume_db",
		DEFAULT_VOLUME_DB,
		music_fade_duration
	)

	var fade_out := create_tween()
	fade_out.tween_property(
		old_player,
		"volume_db",
		SILENT_VOLUME_DB,
		music_fade_duration
	)

	await fade_out.finished
	old_player.stop()

func play_music_from_start(audio: AudioStream) -> void:
	if audio == null:
		return

	var old_player := music_players[current_music_player]

	current_music_player = (current_music_player + 1) % music_audio_player_count

	var new_player := music_players[current_music_player]

	new_player.stream = audio
	new_player.volume_db = SILENT_VOLUME_DB
	new_player.play(0.0)

	var fade_in := create_tween()
	fade_in.tween_property(
		new_player,
		"volume_db",
		DEFAULT_VOLUME_DB,
		music_fade_duration
	)

	var fade_out := create_tween()
	fade_out.tween_property(
		old_player,
		"volume_db",
		SILENT_VOLUME_DB,
		music_fade_duration
	)

	await fade_out.finished
	old_player.stop()

func play_and_fade_in( player : AudioStreamPlayer ) -> void:
	player.play( 0 )
	var tween : Tween = create_tween()
	tween.tween_property( player, 'volume_db', 0, music_fade_duration )
	pass


func fade_out_and_stop( player : AudioStreamPlayer ) -> void:
	var tween : Tween = create_tween()
	tween.tween_property( player, 'volume_db', -40, music_fade_duration )
	await tween.finished
	player.stop()
	pass


func get_current_track() -> AudioStream:
	return music_players[ current_music_player ].stream
	
func stop_music() -> void:
	var old_player := music_players[current_music_player]

	if not old_player.playing:
		return

	var tween := create_tween()
	tween.tween_property(
		old_player,
		"volume_db",
		SILENT_VOLUME_DB,
		music_fade_duration
	)

	await tween.finished
	old_player.stop()
	old_player.volume_db = DEFAULT_VOLUME_DB
