extends CharacterBody2D # Use CharacterBody2D in Godot 4

@export var speed = 200
@export var gravity = 800
@export var jump_force = -400
#var FLOOR_NORMAL := Vector2.UP
func _ready():
	#$RayCast2D.c

	pass

func is_on_floor_custom():
	print(velocity.y)
	#return velocity.y > 0
	#return $RayCast2D.is_colliding() # True if touching the floor
	# check if its touching the floor, floor = tilesheet bottom
	return is_on_floor()
func _physics_process(delta):
	if not is_on_floor_custom():
		velocity.y += gravity * delta # Apply gravity
	
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		#$CharacterBody2D.flip_h = true
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed

	if is_on_floor_custom() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_force # Jump
	# this is broken find out why
	# if velocity.x > 0:
	# 	$CharacterBody2D.flip_h = false
	# elif velocity.x < 0:
	# 	$CharacterBody2D.flip_h = true

	# move_and_slide() # No need to redefine velocity in Godot 4
	move_and_slide()
