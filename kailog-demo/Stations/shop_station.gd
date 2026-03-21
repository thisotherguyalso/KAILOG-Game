## Buy station. Click/tap to purchase the configured item.
## Each click buys one and spawns it as a pickup.
class_name ShopStation
extends Station

@export var item_for_sale: Item
@export var buy_price: float = 15.0


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	var clicked := false

	if (event is InputEventMouseButton
			and event.button_index == MOUSE_BUTTON_LEFT
			and event.pressed):
		clicked = true
	elif event is InputEventScreenTouch and event.pressed:
		clicked = true

	if clicked:
		interact()


func interact() -> void:
	if item_for_sale == null:
		return
	if not player.money.can_afford(buy_price):
		# TODO: show "not enough money" feedback.
		return

	player.money.deduct(buy_price)
	_spawn_pickup(item_for_sale.duplicate())

	# Quick feedback pulse on purchase.
	_tween_scale(HOVER_SCALE)
	await get_tree().create_timer(0.1).timeout
	_tween_scale(NORMAL_SCALE)


func _spawn_pickup(item: Item) -> void:
	var pickup := preload("res://Items/pickup_item.tscn").instantiate()
	pickup.item = item
	pickup.global_position = global_position + Vector2(randi_range(-50, 50), 40)
	get_parent().add_child(pickup)
