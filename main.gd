extends Node2D  

@onready var sprite = $Ship
func _ready():
	await get_tree().process_frame  # Ensure nodes are fully loaded
	print(get_tree().current_scene)  # Debug which scene is loaded
	print(get_node_or_null("Ship"))  # Check if it exists
	pass
	

@export var speed = 150 # Speed in pixels per second
@export var stop_moving = false
@export var i = 0;
func _process(delta):
	#print(sprite, $Node2D, $AnimatedSprite2D)
	var direction = Vector2.ZERO # No movement by default
	i += 1
	#if Input.is_action_pressed("move_right"):
		#direction.x += 1
	#if Input.is_action_pressed("move_left"):
		#direction.x -= 1
	#if Input.is_action_pressed("move_down"):
		#direction.y += 1
	if stop_moving == false and i > 50:
		direction.x += .1  + ((i % 100) * 0.01)
		var rand = randf_range(0,10)
		if i > 300:
			if rand > 5:
				direction.y -= (00.1 + ((i % 100) * 0.01)) 
			else:
				direction.y += (00.1 + ((i % 100) * 0.01)) 
		if sprite.position.x > 1300:
			print(sprite.position)
			stop_moving = true
			get_tree().change_scene_to_file("res://main____inside_the_ship.tscn")
		direction = direction.normalized() # Normalize diagonal movement
		sprite.position += direction * speed * delta
