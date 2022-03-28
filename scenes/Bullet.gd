extends Area2D

var SPEED = 300


func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node):
	print("meh")


func _physics_process(delta):
	position += SPEED * transform.x * delta
