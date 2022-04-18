extends Area2D

onready var timer = $Timer


func _ready():
	connect("body_entered", self, "_on_body_entered")
	timer.connect("timeout", self, "_on_timeout")


func _on_body_entered(body: Node):
	print("F")
	timer.start()
	yield(get_tree().create_timer(1), "timeout")
	print("Restart")


func _on_timeout():
	get_tree().reload_current_scene()
	
