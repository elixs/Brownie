extends KinematicBody2D

var SPEED = 100
var ACCELERATION = 500
var GRAVITY = 400

var velocity = Vector2()


onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")


func _ready():
	anim_tree.active = true

func _physics_process(delta):
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION)
	
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -2 * SPEED
	
	# Animation
	
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
		sprite.flip_h = false
	if Input.is_action_pressed("move_left") and not Input.is_action_just_pressed("move_right"):
		sprite.flip_h = true
	
	
	
