extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	#print("#event")
	#print(event is InputEventMouseButton)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):  # Check if click is inside sprite
			$SelectEffect.play()
			print("click ")
			await get_tree().create_timer(.1).timeout 
			get_tree().change_scene_to_file("res://main.tscn")
