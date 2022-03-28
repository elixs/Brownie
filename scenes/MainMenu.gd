extends MarginContainer


onready var play = $PanelContainer/VBoxContainer/Play
onready var exit = $PanelContainer/VBoxContainer/Exit


func _ready():
	play.connect("pressed", self, "_on_play_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")


func _on_play_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_exit_pressed():
	get_tree().quit()
