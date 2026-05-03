## Destroys any item dropped onto it.
class_name TrashStation
extends Station

@export var dirty_pickups : Array[PackedScene]

func can_receive(_item: Item) -> bool:
	
	return true


func receive_item(_item: Item) -> void:
	$TrashSFX.play(0.74)
	# TODO: play destruction particles
	pass  # Pickup already freed by base class.


# ── Getting stuff (click) ───────────────────────────────────────────────────────────

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	var clicked := false
	if (event is InputEventMouseButton
			and event.button_index == MOUSE_BUTTON_LEFT
			and event.pressed):
		clicked = true
	elif event is InputEventScreenTouch and event.pressed:
		clicked = true
	if clicked:
		interact()

func interact() -> void:
	$TrashSFX.play(0.0)
	_spawn_pickup(dirty_pickups.pick_random())
	_tween_scale(HOVER_SCALE)
	await get_tree().create_timer(0.1).timeout
	_tween_scale(NORMAL_SCALE)

# ── Helpers ──────────────────────────────────────────────────────────────────

func _get_sell_price(item: Item) -> float:
	if item is ItemContainer:
		return item.get_sell_price()
	return 0.0

func _spawn_pickup(item: PackedScene) -> void:
	var pickup := item.instantiate()
	pickup.global_position = global_position + Vector2(randi_range(-100, 100), 170)
	get_parent().add_child(pickup)
