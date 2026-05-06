## A single entry in the grocery list.
class_name GroceryEntry
extends Resource

@export var texture: Texture2D
@export var content: String 
@export var needed_quantity: int = 1
var current_quantity = 0
