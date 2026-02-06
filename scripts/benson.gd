extends CharacterBody3D

@export var speed : float = 2.0
@export var jump_velocity: float = 4.5
@export var flight_velocity: float = 1
@export var flight_time: float = 1.0
var flying : bool = false
var current_flight_time: float = 0

@onready var camarm : SpringArm3D = $CameraArm

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		flying = false
	
	# Handle flight.
	if is_on_floor():
		current_flight_time = 0
	if Input.is_action_just_released("jump"):
		flying = true
	if Input.is_action_pressed("ui_accept") and !is_on_floor() and current_flight_time < flight_time and flying:
		velocity.y = flight_velocity
		current_flight_time += delta

	# Get the input direction and handle the movement/deceleration.
	var input_vector : Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("forward") - Input.get_action_strength("back")
	)
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		
		var camera_basis = camarm.global_transform.basis
		
		var forward = camera_basis.z
		forward.y = 0
		forward = forward.normalized()
		
		var right = camera_basis.x
		right.y = 0
		right = right.normalized()
		
		var move_direction = (input_vector.x * right + input_vector.y * forward).normalized()
		velocity.x = move_direction.x * speed
		velocity.z = move_direction.z * speed
	else:
		velocity.x = 0
		velocity.z = 0
		
	move_and_slide()
