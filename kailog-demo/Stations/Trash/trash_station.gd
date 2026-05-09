## Destroys any item dropped onto it.
class_name TrashStation
extends Station

@export var dirty_pickups : Array[ItemContainer]
@export var wait_time: float = 1.0

var _is_busy = false

func can_receive(_item: Item) -> bool:
	return true

func receive_item(_item: Item) -> void:
	$TrashSFX.play(0.9)
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
	if _is_busy:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		interact()
	elif event is InputEventScreenTouch and event.pressed:
		interact()

func interact() -> void:
	_is_busy = true
	$FindingTrashSFX.play()
	_show_progress(wait_time)
	await get_tree().create_timer(wait_time).timeout
	$FindingTrashSFX.stop()
	$TrashSFX.play(0.9)
	_hide_progress()
	_spawn_pickup(dirty_pickups.pick_random())
	_is_busy = false

# ── Helpers ──────────────────────────────────────────────────────────────────

func _get_sell_price(item: Item) -> float:
	if item is ItemContainer:
		return item.get_sell_price()
	return 0.0
