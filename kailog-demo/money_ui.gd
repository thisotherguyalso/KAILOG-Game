extends Control

@onready var money_text = $MoneyText

func _ready():
	EventBus.money_changed.connect(_on_money_changed)

func _on_money_changed(amount: float):
	money_text.text = str(amount)
