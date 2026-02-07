extends CharacterBody3D

@export var speed : float = 5.0
@export var flight_speed : float = 10.0
@export var friction : float = 0.9
@export var air_friction : float = 0.97
@export var jump_velocity: float = 4.5

@export var flight_velocity: float = 0.5
@export var flight_time: float = 0.8
@export var max_flight_speed: float = 4

@export var dash_velocity: float = 10
var flying : bool = false
var current_flight_time: float = 0
var current_velocity : Vector3 = Vector3(0, 0, 0)

@onready var body: Node3D = $Orientation
@onready var camarm : SpringArm3D = $CameraArm
@onready var buzzer: AudioStreamPlayer3D = $Buzzer

## Emits each frame the player is flying.
## TODO: retarded
signal flew(new_time)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	up_direction = Vector3.UP

func _physics_process(delta: float) -> void:
	
	velocity = current_velocity
	
	# Add the gravity.
	if not is_on_floor() and !is_on_wall_only():
		var gravity_strength := get_gravity().length()
		velocity += -up_direction * gravity_strength * delta
	
	# grabbing wall
	if is_on_wall_only():
		var wall_normal = get_wall_normal()
		velocity = Vector3(0, 0, 0)
		up_direction = wall_normal
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity += up_direction * jump_velocity
		up_direction = Vector3.UP
		flying = false
	
	# Handle flight.
	if is_on_floor():
		current_flight_time = 0
		buzzer.stop()
		flying = false
	if Input.is_action_just_released("jump"):
		flying = true
	if Input.is_action_pressed("ui_accept") and !is_on_floor() and current_flight_time < flight_time and flying and velocity.y <= max_flight_speed:
		if not buzzer.playing:
			buzzer.play()
		if(velocity.y < 0):
			velocity.y = 0
		velocity.y += flight_velocity
		current_flight_time += delta
		flew.emit(current_flight_time)

	# Get the input direction and handle the movement/deceleration.
	var input_vector : Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("forward") - Input.get_action_strength("back")
	)
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		
		var camera_basis = camarm.global_transform.basis
		
		var forward = -camera_basis.z
		forward.y = 0
		forward = forward.normalized()
		
		var right = camera_basis.x
		right.y = 0
		right = right.normalized()
		
		var move_direction = (input_vector.x * right + input_vector.y * forward).normalized()
		
		if is_on_floor() or is_on_wall_only():
			velocity.x += move_direction.x * speed * delta
			velocity.z += move_direction.z * speed * delta
		else:
			velocity.x += move_direction.x * flight_speed * delta
			velocity.z += move_direction.z * flight_speed * delta
		
		var target_angle := Vector3.BACK.signed_angle_to(move_direction, Vector3.UP)
		body.global_rotation.y = target_angle
		
		#handle dash
		if Input.is_action_just_pressed("dash") and !is_on_floor() and current_flight_time < flight_time:
			velocity = -camera_basis.z * dash_velocity;
	
	if is_on_floor():
		velocity.x *= friction
		velocity.z *= friction
	else:
		velocity.x *= air_friction
		velocity.z *= air_friction
	
	move_and_slide()
	
	print(up_direction)
	
	current_velocity = velocity

## "Refreshes" the players flight time. This method could techincally be placed
## in any object that flys.
func refresh():
	current_flight_time = 0
