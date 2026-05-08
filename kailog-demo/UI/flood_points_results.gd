class_name FloodPointsResults
extends Control

const BAR_TWEEN_DURATION := 0.3
const BAR_SLIDE_DURATION := 0.5
const BAR_SLIDE_DISTANCE := 300.0

@export var log_entry_result_scene: PackedScene
@export var max_flood_points: int = 100

@onready var flood_bar: ProgressBar = $FloodBar
@onready var vbox: VBoxContainer = $ScrollContainer/VBoxContainer

var log_list: Array[LogEntry] = []
var current_flood: int = 0
var bar_final_position: Vector2

func _ready():
	hide()
	await get_tree().process_frame
	bar_final_position = flood_bar.position
	flood_bar.position.x = bar_final_position.x + BAR_SLIDE_DISTANCE

func set_data(list: Array[LogEntry], initial_points: int):
	log_list = list
	current_flood = clamp(initial_points, 0, max_flood_points)

func play():
	flood_bar.max_value = max_flood_points
	flood_bar.value = current_flood
	show()
	await get_tree().process_frame
	await _slide_bar_in()
	await _populate_entries()

func _slide_bar_in():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(flood_bar, "position:x", bar_final_position.x, BAR_SLIDE_DURATION)
	await tween.finished

func _populate_entries():
	for entry in log_list:
		var entry_result: LogEntryResult = log_entry_result_scene.instantiate()
		vbox.add_child(entry_result)
		entry_result.set_data(entry)
		entry_result.play_animation()
		await entry_result.animation_finished
		await _update_bar(entry.points)

func _update_bar(delta: int):
	if delta == 0:
		return
	current_flood = clamp(current_flood + delta, 0, max_flood_points)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(flood_bar, "value", current_flood, BAR_TWEEN_DURATION)
	await tween.finished
