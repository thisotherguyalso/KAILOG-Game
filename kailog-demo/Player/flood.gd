extends Control

@onready var flood_bar: ProgressBar = $ProgressBar

# variables for the flood bar
var flood: float = 0.0
var max_flood: float = 100.0
var flood_rate: float = 2.0

func _ready() -> void:
	update_flood_bar()

func _process(delta: float) -> void:
	if flood < max_flood:
		flooding(delta)

# updates the flood bar
func update_flood_bar() -> void:
	flood_bar.value = flood

# increases the flood bar every second
func flooding(delta) -> void:
	flood += flood_rate * delta
	flood = min(flood, max_flood)
	
	update_flood_bar()
