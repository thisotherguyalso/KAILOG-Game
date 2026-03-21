## Combined buy/sell station.
## - Drop an item onto it → sells the item for money.
## - Click/tap it → buys the configured item.
class_name ShopStation
extends Station

@export var item_for_sale: Item
@export var buy_price: float = 15.0


# ── Selling (pickup lands on station) ────────────────────────────────────────

func can_receive(item: Item) -> bool:
	return _get_sell_price(item) > 0.0


func receive_item(item: Item) -> void:
	if _nearby_player == null:
		return
	var price := _get_sell_price(item)
	_nearby_player.inventory.money += price
	# TODO: show floating "+$X" feedback.


# ── Buying (click) ───────────────────────────────────────────────────────────

func interact(player: Player) -> void:
	if item_for_sale == null:
		return
	if player.inventory.money < buy_price:
		# TODO: show "not enough money" feedback.
		return
	if player.inventory.add_item(item_for_sale):
		player.inventory.money -= buy_price


# ── Helpers ──────────────────────────────────────────────────────────────────

func _get_sell_price(item: Item) -> float:
	if item is ItemContainer:
		return item.get_sell_price()
	return 0.0
