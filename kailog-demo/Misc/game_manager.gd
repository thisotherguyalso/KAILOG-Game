class_name GameManager
extends Node

signal round_started(round_number: int)
signal round_ended(results: RoundResults)

@export var player: Player
@export var evaluation_screen: Control

@onready var timer: RoundTimer = $RoundTimer
@onready var grocery_list: GroceryList = $GroceryList

var current_round: int = 0


func _ready() -> void:
	timer.timeout.connect(_on_time_expired)
	grocery_list.list_completed.connect(_on_list_completed)
	# Defer so all sibling/child nodes (Player, GroceryList, etc.) are ready.
	start_round.call_deferred()


# ── Round flow ───────────────────────────────────────────────────────────────

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
	# Player finished early — bonus! Still end the round.
	end_round()


# ── Evaluation ───────────────────────────────────────────────────────────────

func _evaluate() -> RoundResults:
	var results := RoundResults.new()
	results.round_number = current_round
	results.time_remaining = timer.get_seconds_left()
	results.money = player.inventory.money
	results.grocery_complete = grocery_list.is_complete(player)

	# Score each item in the player's inventory.
	for item in player.inventory.get_items():
		if item is ItemContainer:
			match item.state:
				ItemContainer.ContainerState.BOUGHT:
					# Bought but not refilled — wasteful, increases flood.
					results.flood_delta += 1.0
				ItemContainer.ContainerState.REFILLED:
					# Refilled — eco-friendly, decreases flood.
					results.flood_delta -= 1.0
				ItemContainer.ContainerState.CLEAN:
					# Clean but unused — neutral or slight positive.
					results.flood_delta -= 0.5
				ItemContainer.ContainerState.DIRTY:
					# Still dirty — slight negative.
					results.flood_delta += 0.5

	return results


func _show_evaluation(results: RoundResults) -> void:
	if evaluation_screen == null:
		return
	evaluation_screen.visible = true
	# If your evaluation screen has a setup method:
	if evaluation_screen.has_method("show_results"):
		evaluation_screen.show_results(results)


## Call this from the evaluation screen's "Next Round" button.
func proceed_to_next_round() -> void:
	# Clear player inventory for the new round.
	for item in player.inventory.get_items():
		player.inventory.remove_item(item)
	start_round()
