class_name GroceryListResults
extends ColorRect

@export var grocery_entry_result_scene: PackedScene
@onready var flow_container: Container = $VFlowContainer
var grocery_list: Array[GroceryEntry] = []

func set_data(list: Array[GroceryEntry]):
	grocery_list = list

func play():
	await _populate_entries()

func _populate_entries():
	for entry in grocery_list:
		var entry_result: GroceryEntryResult = grocery_entry_result_scene.instantiate()
		flow_container.add_child(entry_result)
		entry_result.set_data(entry)
		entry_result.play_animation()
		await entry_result.animation_finished
