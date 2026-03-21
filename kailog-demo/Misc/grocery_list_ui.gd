class_name GroceryListUI
extends VBoxContainer

@export var game_manager: GameManager

var _entry_labels: Array[Label] = []


func _ready() -> void:
	game_manager.grocery_list.list_updated.connect(_rebuild)
	game_manager.round_started.connect(func(_r): _rebuild())
	game_manager.player.inventory.inventory_changed.connect(_refresh)


func _rebuild() -> void:
	_clear()
	var list := game_manager.grocery_list

	for entry in list.entries:
		var label := Label.new()
		label.add_theme_font_size_override("font_size", 16)
		add_child(label)
		_entry_labels.append(label)

	_refresh()


func _clear() -> void:
	for label in _entry_labels:
		label.queue_free()
	_entry_labels.clear()


## Call this whenever the player's inventory changes.
func refresh() -> void:
	_refresh()


func _refresh() -> void:
	var list := game_manager.grocery_list
	var player := game_manager.player

	for i in list.entries.size():
		if i >= _entry_labels.size():
			break
		var entry := list.entries[i]
		var have := list.get_fulfilled_count(entry, player)
		var done := have >= entry.quantity
		var check := "✓" if done else "○"
		_entry_labels[i].text = "%s %s x%d (%d/%d)" % [
			check, entry.item_name, entry.quantity, have, entry.quantity
		]
