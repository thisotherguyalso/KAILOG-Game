class_name FloatingItem
extends Area2D

signal drag_cancelled(origin_slot_index)

var origin_slot_index: int
var item : Item

func _ready():
	if item:
		$Sprite2D.texture = item.icon

func _physics_process(delta):
	global_position = get_global_mouse_position()

## Logic for when floating item is released
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed:
		var mouse_pos = get_viewport().get_mouse_position()
		
		if _check_inventory_slots_collision(mouse_pos):
			return
		
		drag_cancelled.emit(origin_slot_index)
		queue_free()

## Checks for if the floating item is under an inventory slot.
func _check_inventory_slots_collision(mouse_pos: Vector2) -> bool:
	for slot in get_tree().get_nodes_in_group("Inventory Slot"):
		if slot.get_global_rect().has_point(mouse_pos):
			if slot.is_empty:
				EventBus.item_move_requested.emit(origin_slot_index, slot.slot_index)
				queue_free()
				return true
	return false
