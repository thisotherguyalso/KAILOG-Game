extends Label

func _ready():
	EventBus.money_changed.connect(_on_money_changed)

func _on_money_changed(amount: float):
	text = str(amount)
