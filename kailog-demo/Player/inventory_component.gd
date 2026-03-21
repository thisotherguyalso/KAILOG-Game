class_name InventoryComponent
extends Node

signal inventory_changed

@export var capacity: int = 5

var player: Player

func _ready():
	player = owner


## Returns all items currently in the inventory grid.
func get_items() -> Array[Item]:
	return player.ui.inventory_grid.get_all_items()


func add_item(item: Item) -> bool:
	# Duplicate so each slot holds a unique Resource instance.
	# Without this, preloaded .tres files share the same object
	# and clear_slot_with_item can't distinguish between them.
	var unique_item := item.duplicate() as Item
	var success := player.ui.inventory_grid.add_to_first_empty_slot(unique_item)
	if success:
		inventory_changed.emit()
	return success


func remove_item(item: Item) -> void:
	player.ui.inventory_grid.clear_slot_with_item(item)
	inventory_changed.emit()


func has_item(item: Item) -> bool:
	return item in get_items()
