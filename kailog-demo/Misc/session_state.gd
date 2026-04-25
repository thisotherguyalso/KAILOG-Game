extends Node

var has_saved_money := false
var saved_money := 0.0


func reset_run(starting_money: float) -> void:
	has_saved_money = true
	saved_money = starting_money


func get_money(default_value: float) -> float:
	if has_saved_money:
		return saved_money
	return default_value


func set_money(value: float) -> void:
	has_saved_money = true
	saved_money = value


func clear() -> void:
	has_saved_money = false
	saved_money = 0.0
