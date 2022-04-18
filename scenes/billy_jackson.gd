extends KinematicBody2D

var SPEED = 100
var ACCELERATION = 500
var GRAVITY = 400

var velocity = Vector2()

var health = 100 setget set_health
var max_health = 100

export var firing = false

var Bullet = preload("res://scenes/bullet.tscn")

onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")
onready var bullet_spawn = $Pivot/BulletSpawn
onready var pivot = $Pivot
onready var camera = $Camera2D
onready var health_bar = $CanvasLayer/HealthBar

func _ready():
	anim_tree.active = true
	firing = false
	Manager.meh = 3
	Manager.player = self
	# camera.set_as_toplevel(true)
	health_bar.value = health


func _physics_process(delta):
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	if firing:
		move_input = 0
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION)
	
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -2 * SPEED
	
	
	var has_fired = false
	
	if is_on_floor() and Input.is_action_just_pressed("fire"):
		playback.travel("fire")
		has_fired = true
	
	# Animation
	
	if not has_fired:
		if is_on_floor():
			if abs(velocity.x) > 10:
				playback.travel("walk")
			else:
				playback.travel("idle")
		else:
			if velocity.y > 0:
				playback.travel("fall")
			else:
				playback.travel("jump")

	if Input.is_action_pressed("move_right") and not Input.is_action_just_pressed("move_left"):
		pivot.scale.x = 1
	if Input.is_action_pressed("move_left") and not Input.is_action_just_pressed("move_right"):
		pivot.scale.x = -1

	# follow camera optional
	# camera.global_position = lerp(camera.global_position, global_position, 0.1)

func fire():
	var bullet = Bullet.instance()
	get_parent().add_child(bullet)
	bullet.global_position = bullet_spawn.global_position
	if pivot.scale.x < 0:
		bullet.rotation = PI

func take_damage(instigator: Node2D):
	self.health -= 10


func set_health(value):
	health = value
	health_bar.value = health
