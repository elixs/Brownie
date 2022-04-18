extends Area2D


func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body: Node):
	if body.has_method("take_damage"):
		body.take_damage(self)
