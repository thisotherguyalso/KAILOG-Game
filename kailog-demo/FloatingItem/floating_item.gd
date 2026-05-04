class_name FloatingItem
extends Area2D

signal drag_cancelled(origin_slot_index)

var origin_slot_index: int
var item : Item

func _ready():
	if item:
		$Sprite2D.texture = item.icon

func _physics_process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	$Sprite2D.modulate = _get_highlight_color()

func _get_highlight_color() -> Color:
	for area in get_overlapping_areas():
		if area.is_in_group("Station"):
			return Color.AQUAMARINE if area.can_receive(item) else Color.RED
	return Color.WHITE

## Logic for when floating item is released
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed:
		var mouse_pos = get_viewport().get_mouse_position()
		
		if _check_inventory_slots_collision(mouse_pos):
			return
		
		if _check_station_collision():
			return
		
		drag_cancelled.emit(origin_slot_index)
		queue_free()

func _check_station_collision() -> bool:
	for area in get_overlapping_areas():
		print(area)
		if area.is_in_group("Station"):
			print("fah")
			if area.can_receive(item):
				EventBus.item_removal_requested.emit(origin_slot_index)
				area.receive_item(item)
				queue_free()
				return true
	return false

## Checks for if the floating item is under an inventory slot.
func _check_inventory_slots_collision(mouse_pos: Vector2) -> bool:
	for slot in get_tree().get_nodes_in_group("Inventory Slot"):
		if slot.get_global_rect().has_point(mouse_pos):
			if slot.is_empty:
				EventBus.item_move_requested.emit(origin_slot_index, slot.slot_index)
				queue_free()
				return true
	return false
