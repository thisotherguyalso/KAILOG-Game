## Tracks the player's money.
class_name MoneyComponent
extends Node

signal money_changed(new_amount: float)

@export var starting_money: float = 100.0

var amount: float = 0.0

func _ready() -> void:
	amount = starting_money

func add(value: float) -> void:
	amount += value
	money_changed.emit(amount)

func deduct(value: float) -> bool:
	if amount < value:
		return false
	amount -= value
	money_changed.emit(amount)
	return true

func can_afford(value: float) -> bool:
	return amount >= value

func reset() -> void:
	amount = starting_money
	money_changed.emit(amount)
