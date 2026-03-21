class_name RoundTimer
extends Timer


func _ready() -> void:
	one_shot = true


func start_round() -> void:
	start()


## Seconds remaining in the round.
func get_seconds_left() -> float:
	return time_left


## Formatted as "M:SS" for UI display.
func get_time_string() -> String:
	var total := ceili(time_left)
	return "%d:%02d" % [total / 60, total % 60]
