class_name GroceryListResults
extends ColorRect

@export var grocery_entry_result_scene: PackedScene

@onready var flow_container: Container = $VFlowContainer

const SLIDE_DURATION := 0.4
const SLIDE_DISTANCE := 200.0

var grocery_list: Array[GroceryEntry] = []
var final_position: Vector2

func _ready():
	await get_tree().process_frame
	final_position = position
	scale.x = 0.0
	position.x = final_position.x - SLIDE_DISTANCE

func set_data(list: Array[GroceryEntry]):
	grocery_list = list

func play():
	await _slide_in()
	await _populate_entries()

func _slide_in():
	pivot_offset = Vector2(0, size.y / 2)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale:x", 1.0, SLIDE_DURATION)
	tween.tween_property(self, "position:x", final_position.x, SLIDE_DURATION)
	await tween.finished

func _populate_entries():
	for entry in grocery_list:
		var entry_result: GroceryEntryResult = grocery_entry_result_scene.instantiate()
		flow_container.add_child(entry_result)
		entry_result.set_data(entry)
		entry_result.play_animation()
		await entry_result.animation_finished
