class_name PlayerUI
extends Control

@onready var inventory_grid: InventoryGrid = $InventoryGrid
@onready var money_label: Label = $MoneyLabel

var player: Player

func _ready():
	player = owner
	_connect_signals.call_deferred()

func _connect_signals() -> void:
	player.money.money_changed.connect(_on_money_changed)
	_on_money_changed(player.money.amount)

## Called by InventoryGrid when a drag ends outside any slot.
## Always spawns a pickup. Stations detect it via area overlap.
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

func _on_money_changed(new_amount: float) -> void:
	money_label.text = "₱%.2f" % new_amount
