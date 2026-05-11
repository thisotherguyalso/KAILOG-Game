class_name PointsComponent
extends Node

var maximum : int = 100
var points: int = maximum/2

func _ready() -> void:
	EventBus.points_changed.connect(_on_points_changed)

func _on_points_changed(amount: int) -> void:
	points += amount
	EventBus.flood_meter_changed.emit(points)
