tool
class_name Slot

extends TextureRect

signal selected

export(Texture) var empty_texture
export(Texture) var full_texture
export var empty = true setget set_empty

var item: Node2D = null setget set_item

onready var holder = $Holder


func _ready():
	connect("gui_input", self, "_on_gui_input")


func set_empty(value):
	empty = value
	texture = empty_texture if empty else full_texture


func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("select") and not event.is_echo():
		emit_signal("selected")


func set_item(value):
	item = value
	if item:
		if item.get_parent():
			item.get_parent().remove_child(item)
		holder.add_child(item)
		item.position = Vector2.ZERO
		self.empty = false
	else:
		self.empty = true
