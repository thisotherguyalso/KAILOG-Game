extends Control

signal countdown_finished

@onready var label: Label = $Label
@onready var count_down_sfx = $CountDownSFX

var _timer: Timer
var _count: int = 3


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

	_timer = Timer.new()
	_timer.wait_time = 1.0
	_timer.one_shot = false
	_timer.timeout.connect(_on_tick)
	add_child(_timer)

	_show_count(3)
	count_down_sfx.play()
	_timer.start()


func _show_count(value: int) -> void:
	label.text = str(value)
	label.scale = Vector2.ZERO
	label.pivot_offset = label.size / 2.0

	var tween: Tween = create_tween()
	tween.tween_property(label, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _show_go() -> void:
	label.text = "GO!"
	label.scale = Vector2.ZERO
	label.pivot_offset = label.size / 2.0

	var tween: Tween = create_tween()
	tween.tween_property(label, "scale", Vector2.ONE, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(_finish)


func _on_tick() -> void:
	_count -= 1

	if _count > 0:
		_show_count(_count)
	else:
		_timer.stop()
		_show_go()


func _finish() -> void:
	await get_tree().create_timer(0.8).timeout
	hide()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	countdown_finished.emit()
