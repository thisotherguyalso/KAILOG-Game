class_name PointsComponent
extends Node

var points: int = 10

func _ready() -> void:
	EventBus.points_changed.connect(_on_points_changed)

func _on_points_changed(amount: int) -> void:
	points += amount
	EventBus.flood_meter_changed.emit(points)
