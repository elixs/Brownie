extends Area2D

var SPEED = 300


func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage(self)


func _physics_process(delta):
	position += SPEED * transform.x * delta
