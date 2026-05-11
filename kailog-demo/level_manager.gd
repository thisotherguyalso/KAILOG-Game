class_name LevelManager
extends Node

@export var levels: Array[PackedScene]
@export var money_component : MoneyComponent
@export var points_component : PointsComponent
@export var log_component : LogComponent
@export var main_scene : Node2D

var current_level_index = 0
var current_level : Node2D

func _ready():
	EventBus.next_level_requested.connect(next_level)
	next_level()

func next_level():
	if current_level_index >= levels.size():
		get_tree().change_scene_to_file("res://main_menu.tscn")
		EventBus.end_game.emit()
		return
	if current_level:
		current_level.queue_free()
	instantiate_new_level(levels[current_level_index])
	current_level_index += 1

func instantiate_new_level(level_scene: PackedScene):
	var new_level = level_scene.instantiate()
	current_level = new_level
	var round_manager : RoundManager = new_level.get_node("RoundManager")
	print("found new level")
	if !round_manager:
		return
	
	main_scene.add_child.call_deferred(new_level)
	round_manager.money_component = money_component
	round_manager.points_component = points_component
	round_manager.log_component = log_component
