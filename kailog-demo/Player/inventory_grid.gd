class_name InventoryGrid
extends HBoxContainer

## Tracks the in-progress drag operation. Null when idle.
var _drag: DragState = null


# ── Drag state ───────────────────────────────────────────────────────────────

class DragState:
	var item: Item
	var from_slot: InventorySlot
	var floating_icon: TextureRect

	func _init(p_item: Item, p_slot: InventorySlot, p_icon: TextureRect) -> void:
		item = p_item
		from_slot = p_slot
		floating_icon = p_icon


# ── Input handling ───────────────────────────────────────────────────────────

func _input(event: InputEvent) -> void:
	if _drag == null:
		return

	var pos: Vector2
	var is_move := false
	var is_release := false

	if event is InputEventMouseMotion:
		is_move = true
		pos = event.global_position
	elif event is InputEventScreenDrag:
		is_move = true
		pos = event.position
	elif event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and not event.pressed:
		is_release = true
		pos = event.global_position
	elif event is InputEventScreenTouch and not event.pressed:
		is_release = true
		pos = event.position

	if is_move:
		_move_floating_icon(pos)
	elif is_release:
		_finish_drag(pos)


# ── Public API ───────────────────────────────────────────────────────────────

## Called by InventorySlot when the player presses on a filled slot.
func start_drag(slot: InventorySlot, pos: Vector2) -> void:
	if slot.item == null:
		return

	var icon := _create_floating_icon(slot.item, pos)
	_drag = DragState.new(slot.item, slot, icon)

	# Visually clear the source slot while dragging.
	slot.set_item(null)


## Tries to place an item in the first empty slot. Returns false if full.
func add_to_first_empty_slot(item: Item) -> bool:
	var slot := _find_first_empty_slot()
	if slot == null:
		return false
	slot.set_item(item)
	return true


## Clears the first slot containing the given item.
func clear_slot_with_item(item: Item) -> void:
	var slot := _find_slot_with_item(item)
	if slot:
		slot.set_item(null)


## Returns every non-null item across all slots.
func get_all_items() -> Array[Item]:
	var result: Array[Item] = []
	for slot: InventorySlot in get_children():
		if slot.item != null:
			result.append(slot.item)
	return result


# ── Drag internals ───────────────────────────────────────────────────────────

func _move_floating_icon(pos: Vector2) -> void:
	if _drag and _drag.floating_icon:
		_drag.floating_icon.global_position = pos - Vector2(128, 128)


func _finish_drag(pos: Vector2) -> void:
	var target_slot := _get_hovered_slot(pos)

	if target_slot:
		# Dropped onto a slot → swap (or just place if target is empty).
		_swap_slots(_drag.from_slot, target_slot)
	else:
		# Dropped outside all slots → drop item into the world.
		# from_slot was already cleared in start_drag, so just tell PlayerUI.
		get_parent().handle_world_drop(_drag.item, pos)

	_cleanup_drag()


func _swap_slots(from: InventorySlot, to: InventorySlot) -> void:
	# `from` is currently empty (cleared at drag start).
	# `to` might have an item that needs to move to `from`.
	from.set_item(to.item)
	to.set_item(_drag.item)


func _cleanup_drag() -> void:
	if _drag.floating_icon:
		_drag.floating_icon.queue_free()
	_drag = null


# ── Helpers ──────────────────────────────────────────────────────────────────

func _create_floating_icon(item: Item, pos: Vector2) -> TextureRect:
	var icon := TextureRect.new()
	icon.texture = item.icon
	icon.z_index = 100
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_parent().get_parent().add_child(icon)
	icon.global_position = pos - Vector2(128, 128)
	return icon


func _get_hovered_slot(pos: Vector2) -> InventorySlot:
	for slot: InventorySlot in get_children():
		if slot.is_hovered(pos):
			return slot
	return null


func _find_first_empty_slot() -> InventorySlot:
	for slot: InventorySlot in get_children():
		if slot.item == null:
			return slot
	return null


func _find_slot_with_item(item: Item) -> InventorySlot:
	for slot: InventorySlot in get_children():
		if slot.item == item:
			return slot
	return null
