## Tracks the player's money.
class_name MoneyComponent
extends Node

@export var starting_money: int = 100

var amount: int = 0

func _ready() -> void:
	amount = starting_money
	EventBus.item_refilled.connect(deduct)
	EventBus.item_sold.connect(add)
	EventBus.item_purchase_requested.connect(_on_purchase_requested)

func _on_purchase_requested(cost: int) -> void:
	if not can_afford(cost):
		return
	deduct(cost)
	EventBus.item_bought.emit()

func add(value: int) -> void:
	amount += value
	EventBus.money_changed.emit(amount)

func deduct(value: int) -> bool:
	if amount < value:
		return false
	amount -= value
	EventBus.money_changed.emit(amount)
	return true

func can_afford(value: int) -> bool:
	return amount >= value

func reset() -> void:
	amount = starting_money
	EventBus.money_changed.emit(amount)
