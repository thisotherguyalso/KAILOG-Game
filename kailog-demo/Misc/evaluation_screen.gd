class_name EvaluationScreen
extends Control

@export var game_manager: GameManager

@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var flood_bar: ProgressBar = $Panel/VBoxContainer/FloodContainer/FloodBar
@onready var results_container: VBoxContainer = $Panel/VBoxContainer/ResultsContainer
@onready var next_round_button: Button = $Panel/VBoxContainer/NextRoundButton

const FLOOD_MAX := 100.0
const METER_DURATION := 1.2
const TEXT_STAGGER := 0.3


func _ready() -> void:
	next_round_button.pressed.connect(_on_next_round)
	visible = false


func show_results(results: RoundResults) -> void:
	visible = true
	next_round_button.modulate.a = 0.0

	var is_last_level := game_manager.next_level == "" or not game_manager.next_level in game_manager.levels

	if is_last_level:
		title_label.text = "You saved the planet!"
		next_round_button.text = "Back to Menu"
	elif results.grocery_complete:
		title_label.text = "Complete!"
		next_round_button.text = "Next Round"
	else:
		title_label.text = "Time's Up!"
		next_round_button.text = "Next Round"

	for child in results_container.get_children():
		child.modulate.a = 0.0

	flood_bar.max_value = FLOOD_MAX
	flood_bar.value = results.flood_level_before
	var flood_target := clampf(results.flood_level_before + results.flood_delta * 5.0, 0.0, FLOOD_MAX)

	var labels: Array[Label] = []
	for child in results_container.get_children():
		if child is Label:
			labels.append(child)

	if labels.size() >= 4:
		labels[0].text = "Grocery list: %s" % ("✓ Completed" if results.grocery_complete else "✗ Incomplete")
		labels[1].text = "Time remaining: %s" % _format_time(results.time_remaining)
		labels[2].text = "Money spent: $%.2f" % (100.0 - results.money)
		labels[3].text = "Money saved: $%.2f" % results.money

	var flood_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	flood_tween.tween_property(flood_bar, "value", flood_target, METER_DURATION)

	if flood_target > results.flood_level_before:
		flood_bar.modulate = Color(1.0, 0.4, 0.2)
	else:
		flood_bar.modulate = Color(0.3, 0.85, 0.4)

	var delay := METER_DURATION + 0.2
	for label in labels:
		var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		t.tween_interval(delay)
		t.tween_property(label, "modulate:a", 1.0, 0.25)
		delay += TEXT_STAGGER

	var btn_tween := create_tween()
	btn_tween.tween_interval(delay)
	btn_tween.tween_property(next_round_button, "modulate:a", 1.0, 0.3)


func _on_next_round() -> void:
	game_manager.proceed_to_next_round()
	visible = false


func _format_time(seconds: float) -> String:
	var total := ceili(seconds)
	return "%d:%02d" % [total / 60, total % 60]
