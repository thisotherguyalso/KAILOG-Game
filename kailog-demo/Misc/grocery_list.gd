## Generates and tracks a grocery list for each round.
class_name GroceryList
extends Node

signal list_updated
signal list_completed

@export var possible_items: Array[String] = []
@export var min_entries: int = 2
@export var max_entries: int = 4
@export var max_quantity: int = 3
@export var hardcoded_entries: Array[GroceryEntry] = []

var entries: Array[GroceryEntry] = []

const LEVEL_LISTS: Dictionary = {
	"level_1": [
		{"item_name": "Suka",   "quantity": 2},
		{"item_name": "Bigas",  "quantity": 1},
	],
	"level_2": [
		{"item_name": "Suka",        "quantity": 1},
		{"item_name": "Toyo",        "quantity": 1},
		{"item_name": "Dishwashing Liquid", "quantity": 1},
		{"item_name": "Rice",        "quantity": 1},
	],
	"level_3": [
		{"item_name": "Suka",        "quantity": 1},
		{"item_name": "Rice",        "quantity": 1},
		{"item_name": "Toyo",        "quantity": 1},
		{"item_name": "Cooking Oil", "quantity": 1},
		{"item_name": "Dishwashing Liquid", "quantity": 1},
	],
}

func generate() -> void:
	entries.clear()
	# Hardcoded inspector entries take priority
	if not hardcoded_entries.is_empty():
		entries = hardcoded_entries.duplicate()
		list_updated.emit()
		return
	# Try to match current scene name to LEVEL_LISTS
	var scene_name := get_tree().current_scene.scene_file_path.get_file().get_basename()
	if LEVEL_LISTS.has(scene_name):
		for data in LEVEL_LISTS[scene_name]:
			var entry := GroceryEntry.new()
			entry.item_name = data["item_name"]
			entry.quantity = data["quantity"]
			entries.append(entry)
		list_updated.emit()
		return
	# Fallback to random generation
	var count := randi_range(min_entries, max_entries)
	var pool := possible_items.duplicate()
	pool.shuffle()
	for i in mini(count, pool.size()):
		var entry := GroceryEntry.new()
		entry.item_name = pool[i]
		entry.quantity = randi_range(1, max_quantity)
		entries.append(entry)
	list_updated.emit()

func get_fulfilled_count(entry: GroceryEntry, player: Player) -> int:
	var count := 0
	for item in player.inventory.get_items():
		if item is ItemContainer and item.contents == entry.item_name:
			count += 1
	return count

func is_complete(player: Player) -> bool:
	if entries.is_empty():
		return false
	for entry in entries:
		if get_fulfilled_count(entry, player) < entry.quantity:
			return false
	return true

func check_completion(player: Player) -> void:
	list_updated.emit()
	if is_complete(player):
		list_completed.emit()
