extends ProgressBar

@export var maximum : int = 100

func _ready() -> void:
	max_value = maximum
	value = max_value/2
	EventBus.flood_meter_changed.connect(_on_flood_meter_changed)

func _on_flood_meter_changed(points: int) -> void:
	print("fah!sa")
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "value", points, 0.5)
