## Destroys any item dropped onto it.
class_name TrashStation
extends Station

@export var dirty_pickups : Array[ItemContainer]

func can_receive(_item: Item) -> bool:
	return true

func receive_item(_item: Item) -> void:
	$TrashSFX.play(0.74)
	EventBus.points_changed.emit(check_points(_item))
	# TODO: play destruction particles

func check_points(item: Item) -> int:
	var container := item as ItemContainer
	if container.state == container.ContainerState.DIRTY:
		return -2
	elif container.state != container.ContainerState.CLEAN:
		return 1
	return 0

# ── Getting stuff (click) ───────────────────────────────────────────────────────────

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		interact()
	elif event is InputEventScreenTouch and event.pressed:
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
