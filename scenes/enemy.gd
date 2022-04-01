class_name Enemy
extends KinematicBody2D

onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")
onready var detection_area = $DetectionArea

var SPEED = 50
var ACCELERATION = 200
var GRAVITY = 400

var _target: Node2D = null

var velocity = Vector2()

func _ready():
	anim_tree.active = true
	detection_area.connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var move_input = 0
	
	if _target:
		move_input = sign(_target.global_position.x - global_position.x)
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION)
	
	velocity.y += GRAVITY * delta
	
	if _target and is_on_floor() and _target.global_position.y < global_position.y - 20:
		velocity.y = -5 * SPEED

func take_damage(instigator: Node2D):
	velocity = (global_position - instigator.global_position).normalized() * 20 * SPEED

func _on_body_entered(body: Node):
	_target = body
