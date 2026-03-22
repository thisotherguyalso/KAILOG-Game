## Destroys any item dropped onto it.
class_name TrashStation
extends Station


func can_receive(_item: Item) -> bool:
	
	return true


func receive_item(_item: Item) -> void:
	$TrashSFX.play(0.74)
	# TODO: play destruction particles
	pass  # Pickup already freed by base class.
