extends ScrollContainer

signal end_credits
@export var scroll_speed: float

var start_scrolling = false
var current_scroll_interval = 0
var scroll_bar = get_v_scroll_bar()

func _process(delta: float) -> void:
	if scroll_bar.value + scroll_bar.page == scroll_bar.max_value - 1.0:
		print("end of credits")
		end_credits.emit.call_deferred()
	if start_scrolling:
		#print(scroll_bar.value)
		#print(scroll_bar.max_value)
		current_scroll_interval += delta * scroll_speed
		if current_scroll_interval >= 1.0:
			scroll_vertical += current_scroll_interval
			current_scroll_interval = 0
