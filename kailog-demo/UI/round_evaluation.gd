class_name RoundEvaluation
extends Control

@export var round_results: RoundResults

@onready var grocery_results: Control = $GroceryListResults
@onready var money_results: Control = $MoneyResults
@onready var flood_results: Control = $FloodPointsResults
@onready var summary: Control = $FinalResultsSummary
@onready var prompt_label: Label = $PromptLabel

var awaiting_tap: bool = false
var prompt_pulse_tween: Tween

func _ready():
	_run_sequence()

func _run_sequence():
	grocery_results.set_data(round_results.grocery_list)
	await grocery_results.play()
	await _wait_for_tap()
	
	money_results.set_data(round_results.initial_money, round_results.current_money)
	await money_results.play()
	await _wait_for_tap()
	
	flood_results.set_data(round_results.log_list)
	await flood_results.play()
	await _wait_for_tap()
	
	summary.set_data(round_results)
	await summary.play()

func _wait_for_tap():
	_show_prompt()
	awaiting_tap = true
	while awaiting_tap:
		await get_tree().process_frame
	_hide_prompt()

func _show_prompt():
	prompt_label.text = "Tap to continue"
	prompt_label.modulate.a = 0.0
	prompt_label.show()
	var tween = create_tween()
	tween.tween_property(prompt_label, "modulate:a", 1.0, 0.3)
	tween.tween_callback(_pulse_prompt)

func _pulse_prompt():
	prompt_pulse_tween = create_tween().set_loops()
	prompt_pulse_tween.tween_property(prompt_label, "modulate:a", 0.4, 0.6)
	prompt_pulse_tween.tween_property(prompt_label, "modulate:a", 1.0, 0.6)

func _hide_prompt():
	if prompt_pulse_tween:
		prompt_pulse_tween.kill()
	prompt_label.hide()

func _input(event: InputEvent):
	if not awaiting_tap:
		return
	var pressed = (event is InputEventMouseButton and event.pressed) \
		or (event is InputEventScreenTouch and event.pressed)
	if pressed:
		awaiting_tap = false
