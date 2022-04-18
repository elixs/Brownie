extends Node2D


onready var camera = $Camera2D
onready var player = $BillyJackson
onready var enemy = $Enemy


func _process(delta):
	camera.global_position = (player.global_position + enemy.global_position) / 2
	for node in get_tree().get_nodes_in_group("camera_1"):
		node.modulate.a = 0
