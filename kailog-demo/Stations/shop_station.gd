## Buy station. Click/tap to purchase the configured item.
## Each click buys one. Click multiple times for multiple.
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
	if player.inventory.add_item(item_for_sale):
		player.money.deduct(buy_price)
		# Quick feedback pulse on purchase.
		_tween_scale(HOVER_SCALE)
		await get_tree().create_timer(0.1).timeout
		_tween_scale(NORMAL_SCALE)
