class_name EvaluationScreen
extends Control

@export var game_manager: GameManager

@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var results_label: Label = $Panel/VBoxContainer/ResultsLabel
@onready var next_round_button: Button = $Panel/VBoxContainer/NextRoundButton


func _ready() -> void:
	next_round_button.pressed.connect(_on_next_round)
	visible = false


func show_results(results: RoundResults) -> void:
	visible = true

	if results.grocery_complete:
		title_label.text = "Round %d Complete!" % results.round_number
	else:
		title_label.text = "Round %d - Time's Up!" % results.round_number

	var lines: PackedStringArray = []

	lines.append("Grocery list: %s" % ("Completed" if results.grocery_complete else "Incomplete"))
	lines.append("Time remaining: %s" % _format_time(results.time_remaining))
	lines.append("Money: $%.2f" % results.money)
	lines.append("")

	# Flood impact breakdown.
	if results.flood_delta < 0.0:
		lines.append("Flood impact: %.1f (Good!)" % results.flood_delta)
	elif results.flood_delta > 0.0:
		lines.append("Flood impact: +%.1f (Bad!)" % results.flood_delta)
	else:
		lines.append("Flood impact: 0 (Neutral)")

	results_label.text = "\n".join(lines)


func _on_next_round() -> void:
	game_manager.proceed_to_next_round()


func _format_time(seconds: float) -> String:
	var total := ceili(seconds)
	return "%d:%02d" % [total / 60, total % 60]
