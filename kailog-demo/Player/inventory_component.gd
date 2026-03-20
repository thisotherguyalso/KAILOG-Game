class_name InventoryComponent extends Node

@export var capacity: int = 5

var player: Player
var items: Array[Item] = []
var money: float = 100.0

func _ready():
	player = owner

func add_item(item: Item) -> bool:
	if items.size() >= capacity:
		return false
	items.append(item)
	player.ui.inventory_grid.refresh_inventory(items)
	return true

func remove_item(item: Item) -> void:
	items.erase(item)

func has_item(item: Item) -> bool:
	return item in items
