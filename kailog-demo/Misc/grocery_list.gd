## Generates and tracks a grocery list for each round.
##
## Add this as a child of your main scene or GameManager.
## Set `possible_items` in the inspector with all item names that
## can appear on a grocery list (e.g. "coffee", "juice", "water").
class_name GroceryList
extends Node

signal list_updated
signal list_completed

## All possible item content names that can appear on a list.
@export var possible_items: Array[String] = []
## How many entries per round (min and max, picked randomly).
@export var min_entries: int = 2
@export var max_entries: int = 4
## Max quantity per entry.
@export var max_quantity: int = 3

var entries: Array[GroceryEntry] = []


# ── Generation ───────────────────────────────────────────────────────────────

func generate() -> void:
	entries.clear()
	var count := randi_range(min_entries, max_entries)
	var pool := possible_items.duplicate()
	pool.shuffle()

	for i in mini(count, pool.size()):
		var entry := GroceryEntry.new()
		entry.item_name = pool[i]
		entry.quantity = randi_range(1, max_quantity)
		entries.append(entry)

	list_updated.emit()


# ── Checking completion ──────────────────────────────────────────────────────

## Returns how many of a given item the player currently has.
func get_fulfilled_count(entry: GroceryEntry, player: Player) -> int:
	var count := 0
	for item in player.inventory.get_items():
		if item is ItemContainer and item.contents == entry.item_name:
			count += 1
	return count


## Returns true if every entry is fulfilled.
func is_complete(player: Player) -> bool:
	if entries.is_empty():
		return false
	for entry in entries:
		if get_fulfilled_count(entry, player) < entry.quantity:
			return false
	return true


## Call this periodically or after inventory changes to check completion.
func check_completion(player: Player) -> void:
	list_updated.emit()
	if is_complete(player):
		list_completed.emit()
