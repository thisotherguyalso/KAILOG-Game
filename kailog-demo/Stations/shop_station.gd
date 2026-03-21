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
	player.money.add(_get_sell_price(item))
	# TODO: show floating "+$X" feedback.


# ── Buying (click) ───────────────────────────────────────────────────────────

func interact() -> void:
	if item_for_sale == null:
		return
	if not player.money.can_afford(buy_price):
		# TODO: show "not enough money" feedback.
		return
	if player.inventory.add_item(item_for_sale):
		player.money.deduct(buy_price)


# ── Helpers ──────────────────────────────────────────────────────────────────

func _get_sell_price(item: Item) -> float:
	if item is ItemContainer:
		return item.get_sell_price()
	return 0.0
