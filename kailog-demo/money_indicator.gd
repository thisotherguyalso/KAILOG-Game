extends Label

func _ready():
	hide()
	EventBus.connect("item_sold", _on_new_sell)
	EventBus.connect("item_refilled", _on_new_buy)
	EventBus.connect("item_purchase_requested", _on_new_buy)

func _on_new_buy(amount : float):
	text = "-"
	text += str(amount)
	modulate = Color.RED
	_animate()

func _on_new_sell(amount : float):
	text = ""
	text += str(amount)
	modulate = Color.GREEN
	_animate()

func _animate() -> void:
	show()
	var tween = create_tween()
	
	# Reset state
	modulate.a = 0.0
	scale = Vector2(0.8, 0.8)
	
	# Pop in
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.15).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	# Hold for 2s, then fade out
	tween.set_parallel(false)
	tween.tween_interval(2.0)
	tween.tween_property(self, "modulate:a", 0.0, 0.3).set_ease(Tween.EASE_IN)
