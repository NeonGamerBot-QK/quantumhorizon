extends Node2D
var config = ConfigFile.new()
@export var selected_timeline = null;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config.load("user://save_data.cfg")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func navigate_to_timeline(timeline: String):
	print("Woosh... moving to " + timeline)
	config.set_value("level", "timeline", timeline)
	config.set_value("config", "is_playing", "yes")
	config.save("user://save_data.cfg")
	$AudioStreamPlayer2D.play();
	selected_timeline = timeline;
	pass

func _on_red_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		navigate_to_timeline('red') 
	pass # Replace with function body.


func _on_green_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		navigate_to_timeline('green') 
	pass # Replace with function body.


func _on_blue_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		navigate_to_timeline('blue') 
	pass # Replace with function body.


func _on_audio_stream_player_2d_finished() -> void:
	print("what if")
	get_tree().change_scene_to_file('res://main____' + selected_timeline+ '_start.tscn')
	pass # Replace with function body.
