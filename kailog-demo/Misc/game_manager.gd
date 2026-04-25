class_name GameManager
extends Node

signal round_started(round_number: int)
signal round_ended(results: RoundResults)

@export var player: Player
@export var evaluation_screen: Control

@onready var timer: RoundTimer = $RoundTimer
@onready var grocery_list: GroceryList = $GroceryList

@export var levels: Array[String] = [
	"res://level_1.tscn",
	"res://level_2.tscn",
	"res://level_3.tscn"
]
@export var next_level: String = ""

var current_round: int = 1
var current_flood_level: float = 50.0


func _ready() -> void:
	timer.timeout.connect(_on_time_expired)
	grocery_list.list_completed.connect(_on_list_completed)
	start_round.call_deferred()


func start_round() -> void:
	current_round += 1
	grocery_list.generate()
	timer.start_round()
	if evaluation_screen:
		evaluation_screen.visible = false
	round_started.emit(current_round)


func end_round() -> void:
	timer.stop()
	var results := _evaluate()
	round_ended.emit(results)
	_show_evaluation(results)


func _on_time_expired() -> void:
	end_round()


func _on_list_completed() -> void:
	end_round()


func _evaluate() -> RoundResults:
	var results := RoundResults.new()
	results.round_number = current_round
	results.time_remaining = timer.get_seconds_left()
	results.money = player.money.amount
	results.grocery_complete = grocery_list.is_complete(player)
	results.flood_level_before = current_flood_level

	for item in player.inventory.get_items():
		if item is ItemContainer:
			match item.state:
				ItemContainer.ContainerState.BOUGHT:
					results.flood_delta += 1.0
				ItemContainer.ContainerState.REFILLED:
					results.flood_delta -= 1.0
				ItemContainer.ContainerState.CLEAN:
					results.flood_delta -= 0.5
				ItemContainer.ContainerState.DIRTY:
					results.flood_delta += 0.5

	current_flood_level = clampf(current_flood_level + results.flood_delta * 5.0, 0.0, 100.0)
	return results


func _show_evaluation(results: RoundResults) -> void:
	if evaluation_screen == null:
		return
	evaluation_screen.visible = true
	if evaluation_screen.has_method("show_results"):
		evaluation_screen.show_results(results)


# GameManager - proceed_to_next_round updated
func proceed_to_next_round() -> void:
	for item in player.inventory.get_items():
		player.inventory.remove_item(item)
	if next_level != "" and next_level in levels:
		get_tree().change_scene_to_file(next_level)
	else:
		get_tree().change_scene_to_file("res://main_menu.tscn")
