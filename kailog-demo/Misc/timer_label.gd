## Displays the remaining round time as "M:SS".
## Attach to a Label node and set `timer` in the inspector.
class_name TimerLabel
extends Label

@export var timer: RoundTimer


func _process(_delta: float) -> void:
	if timer:
		text = timer.get_time_string()
