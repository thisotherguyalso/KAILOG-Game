class_name PlayerUI
extends Control

@onready var flood_bar: ProgressBar = $FloodBar
@onready var inventory_grid: InventoryGrid = $InventoryGrid

var player: Player

func _ready():
	player = owner

## Called by InventoryGrid when a drag ends outside any slot.
## Spawns the item as a pickup in the world.
func handle_world_drop(item: Item, screen_pos: Vector2) -> void:
	var world_pos := _screen_to_world(screen_pos)
	_spawn_pickup(item, world_pos)
	player.inventory.remove_item(item)

func _screen_to_world(screen_pos: Vector2) -> Vector2:
	return player.get_canvas_transform().affine_inverse() * screen_pos

func _spawn_pickup(item: Item, world_pos: Vector2) -> void:
	var pickup := preload("res://Items/pickup_item.tscn").instantiate()
	pickup.item = item
	pickup.global_position = world_pos
	player.get_parent().add_child(pickup)
