extends Label

func _ready():
	hide()
	EventBus.connect("add_log_entry", _on_new_log)

func _on_new_log(log_entry : LogEntry):
	text = ""
	if log_entry.points >= 0:
		text += "+"
	text += str(log_entry.points)
	
	_set_color(log_entry.points)
	_animate()

func _set_color(points: int) -> void:
	modulate = Color.RED if points >= 0 else Color.GREEN

func _animate() -> void:
	show()
	var tween = create_tween()
	
	# Reset state
	modulate.a = 0.0
	scale = Vector2(0.8, 0.8)
	
	# Pop in
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.15).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	# Hold for 2s, then fade out
	tween.set_parallel(false)
	tween.tween_interval(2.0)
	tween.tween_property(self, "modulate:a", 0.0, 0.3).set_ease(Tween.EASE_IN)
