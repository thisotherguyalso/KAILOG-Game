extends Label

func _ready():
	EventBus.round_timer_ticked.connect(_on_tick)

func _on_tick(time_left: float):
	var total_seconds = int(ceil(time_left))
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	text = "%d:%02d" % [minutes, seconds]
