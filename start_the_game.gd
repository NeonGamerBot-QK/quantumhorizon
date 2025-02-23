extends Sprite2D

var config = ConfigFile.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config.load("user://save_data.cfg")
	print(config.get_value("_dont_tamper_with_this_you_goober", "ok"))
	config.set_value("_dont_tamper_with_this_you_goober", "ok", "yes")
	config.save("user://save_data.cfg")
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
			if(config.get_value("level", "timeline")):
				var floor = config.get_value("level", "floor")
				if(!floor): floor = "start"
				# testing idiot moment
				get_tree().change_scene_to_file('res://testing/player_tilemap.tscn')		
				
				#get_tree().change_scene_to_file('res://main____' + config.get_value("level", "timeline")+ '_'+ (floor)  + '.tscn')		
			else:
				get_tree().change_scene_to_file("res://main.tscn")
