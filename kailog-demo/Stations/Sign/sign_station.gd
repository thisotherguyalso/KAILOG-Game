class_name SignStation
extends Station

@export var sign_text : String = "Do this!"
@export var sign_duration : float = 3.0

func _ready() -> void:
	super._ready()
	$Label.text = sign_text
	$Label.hide()
	$Label.scale = Vector2.ZERO

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		interact()
	elif event is InputEventScreenTouch and event.pressed:
		interact()

func interact() -> void:
	$FinishedSFX.play()
	$Label.show()
	var tween_up = create_tween()
	tween_up.tween_property($Label, "scale", Vector2.ONE, 0.2)
	
	await get_tree().create_timer(sign_duration).timeout
	
	var tween_down = create_tween()
	tween_down.tween_property($Label, "scale", Vector2.ZERO, 0.2)
