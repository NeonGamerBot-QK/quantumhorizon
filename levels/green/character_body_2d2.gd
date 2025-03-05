extends CharacterBody2D


const speed = 300.0
const JUMP_VELOCITY = -350.0
const gravity = 800
@export var index_until_idle = 0;

func is_on_floor_custom():
	#print(velocity.y)
	var tilemap = get_node("../TileMapLayer")
	var tile_pos = tilemap.local_to_map($AnimatedSprite2D.position)  # Convert world position to tilemap coords
	var tile_data = tilemap.get_cell_source_id(tile_pos)
	return is_on_floor()
func _physics_process(delta):
	if not is_on_floor_custom():
		velocity.y += gravity * delta # Apply gravity
	velocity.x = 0  # Reset X velocity each frame
	var screen_size = get_viewport_rect().size  # Get screen size dynamically
	var min_x = 0
	var max_x = screen_size.x - 1  # Adjust based on sprite width

	if Input.is_action_pressed("ui_right"): # and  position.x + speed * delta < max_x:
		velocity.x = speed
		$AnimatedSprite2D.flip_h = false;
		if $AnimatedSprite2D.animation != "run_right":
			$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("run_right");
	elif Input.is_action_pressed("ui_left") and position.x - speed * delta > min_x:
		velocity.x = -speed
		#$AnimatedSprite2D.flip_h = true;
		$AnimatedSprite2D.play("run_left");
	else:
		if $AnimatedSprite2D.animation == "run_right" or $AnimatedSprite2D.animation == "run_left":
			$AnimatedSprite2D.stop()
			print("stop")
		index_until_idle += 1;
		if index_until_idle > 10 and is_on_floor_custom():
			$AnimatedSprite2D.play("idle_"+$AnimatedSprite2D.animation.split('_')[1])
			index_until_idle = 0;

	if is_on_floor_custom() and Input.is_action_just_pressed("ui_up"):
		velocity.y = JUMP_VELOCITY # Jump


	# move_and_slide() # No need to redefine velocity in Godot 4
	move_and_slide()
