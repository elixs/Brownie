extends Node2D


onready var sprite = $Sprite
onready var label = $Label

var id
var icon: Texture setget set_icon
var quantity: int = 99 setget set_quantity


func _ready() -> void:
	self.quantity = quantity
	self.icon = icon


func set_quantity(value: int):
	quantity = value
	if label:
		label.text = str(quantity)


func set_icon(value: Texture):
	icon = value
	if sprite:
		sprite.texture = icon
