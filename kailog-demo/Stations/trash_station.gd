## Destroys any item dropped onto it.
class_name TrashStation
extends Station


func can_receive(_item: Item) -> bool:
	return true


func receive_item(_item: Item) -> void:
	# TODO: play destruction particles / sound.
	pass  # Pickup already freed by base class.
