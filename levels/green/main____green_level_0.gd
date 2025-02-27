extends Node2D

var config = ConfigFile.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	update config
	config.load("user://save_data.cfg")
	#print(config.get_value("_dont_tamper_with_this_you_goober", "ok"))
	if config.get_value("level", "floor") == null:
		config.set_value("level", "floor", "level0")
		config.save("user://save_data.cfg")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
