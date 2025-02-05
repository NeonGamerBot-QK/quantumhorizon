extends Node2D  

@onready var sprite = $AnimatedSprite2D
func _ready():
	# move sprite
	pass
	

@export var speed = 200 # Speed in pixels per second

func _process(delta):
	#print(sprite)
	var direction = Vector2.ZERO # No movement by default

	#if Input.is_action_pressed("move_right"):
		#direction.x += 1
	#if Input.is_action_pressed("move_left"):
		#direction.x -= 1
	#if Input.is_action_pressed("move_down"):
		#direction.y += 1
	direction.y -= 1

	direction = direction.normalized() # Normalize diagonal movement
	#sprite.position += direction * speed * delta
