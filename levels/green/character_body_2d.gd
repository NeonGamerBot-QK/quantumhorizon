extends CharacterBody2D # Use CharacterBody2D in Godot 4

@export var speed = 200
@export var gravity = 800
@export var jump_force = -400 * 2
@export var index_until_idle = 0
#var FLOOR_NORMAL := Vector2.UP
func _ready():
	#$RayCast2D.c
	$AnimatedSprite2D.flip_h = true;
	
	pass

func is_on_floor_custom():
	#print(velocity.y)
	var tilemap = get_node("../TileMapLayer")
	var tile_pos = tilemap.local_to_map($AnimatedSprite2D.position)  # Convert world position to tilemap coords
	var tile_data = tilemap.get_cell_source_id(tile_pos)
	#print(tile_pos, tile_data)
	#return tile_data != -1
	#return get_tree().get_root().find_child("TileMap", true, false).to_local_map($AnimatedSprite2D.position)
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
		$AnimatedSprite2D.flip_h = false;
		if $AnimatedSprite2D.animation != "run_right":
			$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("run_right");
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		#$AnimatedSprite2D.flip_h = true;
		$AnimatedSprite2D.play("run_left");
	else:
		if $AnimatedSprite2D.animation == "run_right" or $AnimatedSprite2D.animation == "run_left":
			$AnimatedSprite2D.stop()
		index_until_idle += 1;
		if index_until_idle > 10 and is_on_floor_custom():
			$AnimatedSprite2D.play("idle_"+$AnimatedSprite2D.animation.split('_')[1])
			index_until_idle = 0;

	if is_on_floor_custom() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_force # Jump
	# this is broken find out why
	# if velocity.x > 0:
	# 	$CharacterBody2D.flip_h = false
	# elif velocity.x < 0:
	# 	$CharacterBody2D.flip_h = true

	# move_and_slide() # No need to redefine velocity in Godot 4
	move_and_slide()
	#var collision = move_and_collide(velocity)

	#if collision:
		#print("Collided with:", collision.get_collider().name)
	#move_and_collide(velocity * delta)
