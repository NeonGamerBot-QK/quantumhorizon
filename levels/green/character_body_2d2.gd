extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
		#$CharacterBody2D.flip_h = true
		$AnimatedSprite2D.flip_h = false;
		if $AnimatedSprite2D.animation != "run_right":
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.play("run_right");
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
		#$AnimatedSprite2D.flip_h = true;
			$AnimatedSprite2D.play("run_left");
		else:
			if $AnimatedSprite2D.animation == "run_right" or $AnimatedSprite2D.animation == "run_left":
				$AnimatedSprite2D.stop()
				#index_until_idle += 1;
			#if index_until_idle > 10 and is_on_floor_custom():
				#$AnimatedSprite2D.play("idle_"+$AnimatedSprite2D.animation.split('_')[1])
				#index_until_idle = 0;

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
