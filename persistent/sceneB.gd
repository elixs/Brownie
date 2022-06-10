extends Node2D


onready var label = $Label


func _ready():
	_update_text()


func _update_text():
	label.text = Persistent.text
