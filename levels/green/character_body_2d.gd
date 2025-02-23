extends CharacterBody2D

## Player movement and physics parameters
@export_group("Movement Parameters")
@export var speed: float = 200.0
@export var acceleration: float = 1000.0
@export var friction: float = 1000.0
@export var air_friction: float = 200.0

@export_group("Jump Parameters")
@export var gravity: float = 800.0
@export var jump_force: float = -400.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1

# Debug variables
@export_group("Debug Settings")
@export var debug_mode: bool = true
@export var debug_color: Color = Color.GREEN

# Node references
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var debug_label: Label = $DebugLabel

# State tracking
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var was_on_floor: bool = false
var current_state: String = "idle"

func _ready() -> void:
	# Create debug label if it doesn't exist
	if debug_mode and not debug_label:
		debug_label = Label.new()
		debug_label.name = "DebugLabel"
		add_child(debug_label)
		debug_label.position = Vector2(0, -50)
	
	# Verify required nodes
	if not sprite:
		push_error("AnimatedSprite2D node not found! Make sure it's named 'AnimatedSprite2D'")
		set_physics_process(false)
		return
	
	# Verify animations
	var required_animations = ["idle", "run", "jump", "fall"]
	for anim in required_animations:
		if not sprite.sprite_frames or not sprite.sprite_frames.has_animation(anim):
			push_error("Missing required animation: " + anim)
			set_physics_process(false)
			return

func _physics_process(delta: float) -> void:
	handle_timers(delta)
	apply_gravity(delta)
	handle_movement(delta)
	handle_jump()
	move_and_slide()
	update_animation()
	update_debug_info()

func handle_timers(delta: float) -> void:
	# Update coyote time
	if is_on_floor():
		coyote_timer = coyote_time
	elif was_on_floor and not is_on_floor():
		coyote_timer = max(0.0, coyote_timer - delta)
	
	# Update jump buffer
	if Input.is_action_just_pressed("ui_up"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer = max(0.0, jump_buffer_timer - delta)
	
	was_on_floor = is_on_floor()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		# Terminal velocity
		velocity.y = min(velocity.y, gravity)

func handle_movement(delta: float) -> void:
	var input_dir = Input.get_axis("ui_left", "ui_right")
	var target_speed = input_dir * speed
	
	# Apply acceleration or friction
	if input_dir != 0:
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		var friction_to_use = friction if is_on_floor() else air_friction
		velocity.x = move_toward(velocity.x, 0, friction_to_use * delta)

func handle_jump() -> void:
	# Regular jump
	if (is_on_floor() or coyote_timer > 0) and (Input.is_action_just_pressed("ui_up") or jump_buffer_timer > 0):
		velocity.y = jump_force
		coyote_timer = 0
		jump_buffer_timer = 0
	
	# Cut jump short when button released
	if Input.is_action_just_released("ui_up") and velocity.y < 0:
		velocity.y *= 0.5

func update_animation() -> void:
	var new_state: String
	
	if not is_on_floor():
		new_state = "jump" if velocity.y < 0 else "fall"
	elif velocity.x != 0:
		new_state = "run"
	else:
		new_state = "idle"
	
	if new_state != current_state:
		current_state = new_state
		sprite.play(current_state)
	
	# Update sprite direction
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

func update_debug_info() -> void:
	if not debug_mode or not debug_label:
		return
	
	var debug_text = """
	State: {state}
	Position: {pos}
	Velocity: {vel}
	On Floor: {floor}
	Coyote Timer: {coyote}
	Jump Buffer: {buffer}
	""".format({
		"state": current_state,
		"pos": position,
		"vel": velocity,
		"floor": is_on_floor(),
		"coyote": coyote_timer,
		"buffer": jump_buffer_timer
	})
	
	debug_label.text = debug_text

func _draw() -> void:
	if debug_mode:
		# Draw velocity vector
		draw_line(Vector2.ZERO, velocity / 10, debug_color, 2)
		# Draw floor check ray
		draw_line(Vector2.ZERO, Vector2(0, 5), debug_color, 2)

func _process(_delta: float) -> void:
	if debug_mode:
		queue_redraw()  # Ensure debug drawings are updated
