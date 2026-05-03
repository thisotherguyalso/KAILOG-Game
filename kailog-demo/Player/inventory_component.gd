class_name InventoryComponent
extends Node

signal item_added(inventory: Array[Item])
signal item_removed(inventory: Array[Item])

var inventory : Array[Item] = [null, null, null, null, null]

func _ready():
	EventBus.item_move_requested.connect(_on_item_move)
	EventBus.item_removed.connect(remove_item)

func add_item(item : Item):
	inventory[_find_first_slot()] = item
	item_added.emit(inventory)
	EventBus.inventory_changed.emit(inventory)

func add_item_to_index(item : Item, index : int):
	inventory[index] = item
	item_added.emit(inventory)
	EventBus.inventory_changed.emit(inventory)

func remove_item(index : int):
	inventory[index] = null
	item_removed.emit(inventory)
	EventBus.inventory_changed.emit(inventory)

func _on_item_move(origin_slot_index, slot_index):
	var temp = inventory[origin_slot_index]
	remove_item(origin_slot_index)
	add_item_to_index(temp, slot_index)

func _find_first_slot() -> int:
	for i in range(inventory.size()):
		if not inventory[i]:
			return i
	return 0
