class_name GroceryEntryUI
extends HBoxContainer

var texture : Texture2D
var contents : String = ""
var current : int = 0
var maximum : int = 0

func _ready():
	$Current.text = str(current)
	$Maximum.text = str(maximum)
	$TextureRect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	$TextureRect.texture = texture
	
