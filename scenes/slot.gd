tool
class_name Slot

extends TextureRect

onready var quantity_label = $QuantityLabel

export(Texture) var empty_texture
export(Texture) var full_texture

var Item = preload("res://scenes/item.tscn")


export var empty = true setget set_empty

var _item setget _set_item
var _quantiy setget set_quantity

func _ready():
	connect("gui_input", self, "_on_gui_input")
	quantity_label.visible = false

func set_empty(value):
	empty = value
	texture = empty_texture if empty else full_texture

func _on_gui_input(event: InputEvent):
	print(event)

func set_item(item, quantity):
	self._item = item
	self._quantiy = quantity

func set_quantity(value):
	_quantiy = value
	if _quantiy > 1:
		quantity_label.visible = true
		quantity_label.text = str(_quantiy)
	else:
		quantity_label.visible = false


func _set_item(value):
	_item = value
	var i = Item.instance()
	i.texture = load("res://assets/sf_items/%s" % _item.icon)
	add_child(i)
