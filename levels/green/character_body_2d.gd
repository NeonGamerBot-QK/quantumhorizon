extends CharacterBody2D # Use CharacterBody2D in Godot 4

@export var speed = 200
@export var gravity = 800
@export var jump_force = -400 * 2
@export var index_until_idle = 0
@onready var camera = $Camera2D
func _ready():
	$AnimatedSprite2D.flip_h = true;
	camera.make_current()  
	pass

func _process(delta):
	pass
	#print(position.y, camera.position.y)
	#var tile_id = get_tile_id_at($AnimatedSprite2D.position)
	#print("Tile ID:", tile_id)
	#if position.y +500 < camera.position.y:  # Move camera up only
		#camera.position.y = lerp(camera.position.y, position.y, delta)
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
	#var screen_center = get_viewport_rect().size / 16
	#var offset_position = position - screen_center * 0.5  # Adjust centering effect
	#camera.position = camera.position.lerp(offset_position,  delta)  # Smooth movement
	var screen_size = get_viewport_rect().size  # Get screen size dynamically
	var min_x = 0
	var max_x = screen_size.x - 150  # Adjust based on sprite width

	if Input.is_action_pressed("ui_right") and  position.x + speed * delta < max_x:
		velocity.x = speed
		#$CharacterBody2D.flip_h = true
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
		index_until_idle += 1;
		if index_until_idle > 10 and is_on_floor_custom():
			$AnimatedSprite2D.play("idle_"+$AnimatedSprite2D.animation.split('_')[1])
			index_until_idle = 0;

	if is_on_floor_custom() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_force # Jump


	# move_and_slide() # No need to redefine velocity in Godot 4
	move_and_slide()


func _on_collision_shape_2d_child_entered_tree(node: Node) -> void:
	print(node.name, "Its IN!!")
	pass # Replace with function body.


func _on_collision_shape_2d_tree_entered() -> void:
	print("um")
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name, "body area2")
	if body.name == "CharacterBody2D":
		print("to the next")
		get_tree().change_scene_to_file('res://levels/green/main____green_level0.tscn')		
		pass
#		print("to the next ")
	pass # Replace with function body.
