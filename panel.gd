extends Sprite2D

@onready var audio_player = $ClickEffect  # Get the sound player
@export var i = 0;
@export var pushed_the_wrong_button_to_much = false;
@export var i2 = 0;
@export var not_error_moment = false;
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		audio_player.play()  # Play the sound
		pushed_the_wrong_button_to_much = true;
		not_error_moment = true;
		# sleep like what 3s
		# play crash sound here (as in like a break sound)
		visible = false 
		pushed_the_wrong_button_to_much = false;
		not_error_moment = false;
		for i in range(5):
			print(i)
			$ErrorEffect.play()
			await get_tree().create_timer(1.0).timeout 
			if i >= 4:
#				# play question sound
				$QuestionEffect.play()
				$Dim.rect_size = get_viewport_rect().size
				# dim stuff ig
				$Dim.modulate.a = 0.5
				# oh yea split into the colors..
				$Dim.raise()
				pass
			
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		print('eastereggmoment')
		$ErrorEffect.play()
		if i > -1:
			i += .1
		else:
			i -= .1
		# crash audio play
		# move sprite a lil
		position += Vector2(-i, i)
		if i > 1 or i < -1:
			pushed_the_wrong_button_to_much = true;
			i = -i 

func _process(delta: float) -> void:
		if pushed_the_wrong_button_to_much:
			i2 += 1
			if not_error_moment:
				i2 += i2/2
			if not_error_moment:
				if i2 % 2 == 0:
					position += Vector2(.5 + (i2/10 % 10), .5+ (i2/10 % 10))
				else:
					position -= Vector2(.5+ (i2/10 % 10), .5+ (i2/10 % 10))
			else:
				if i2 % 2 == 0:
					position += Vector2(1,1)
				else:
					position -= Vector2(1,1)
			if i2 % 100 ==  0:
				$ErrorEffect.play()
			pass
		
