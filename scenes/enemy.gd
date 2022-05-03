class_name Enemy
extends KinematicBody2D

onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")
onready var detection_area = $DetectionArea
onready var attack_area = $AttackArea
onready var attack_cooldown = $AttackCooldown

var SPEED = 50
var ACCELERATION = 200
var GRAVITY = 400

var _target: Node2D = null

var velocity = Vector2()

export var attacking = false

func _ready():
	anim_tree.active = true
	detection_area.connect("body_entered", self, "_on_body_entered")
	attack_area.connect("body_entered", self, "_on_attack_area_body_entered")

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var move_input = 0
	
	if _target:
		var diff = _target.global_position.x - global_position.x
		move_input = sign(diff)
		if attack_cooldown.is_stopped():
			if abs(diff) < 60:
				attacking = true
				attack_cooldown.start()
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION)
	
	velocity.y += GRAVITY * delta
	
	if _target and is_on_floor() and _target.global_position.y < global_position.y - 20:
		velocity.y = -5 * SPEED
	
	if attacking:
		playback.travel("attack")
	else:
		if abs(velocity.x) > 10:
			playback.travel("walk")
		else:
			playback.travel("idle")

func take_damage(instigator: Node2D):
	velocity = (global_position - instigator.global_position).normalized() * 20 * SPEED

func _on_body_entered(body: Node):
	_target = body

func _on_attack_area_body_entered(body: Node):
	if body.has_method("take_damage"):
		body.take_damage(self)
