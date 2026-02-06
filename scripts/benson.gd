extends CharacterBody3D

@export var speed : float = 5.0
@export var jump_velocity: float = 4.5
@export var flight_velocity: float = 1
@export var flight_time: float = 1.0
var flying : bool = false
var current_flight_time: float = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		flying = false
	
	# Handle flight.
	if is_on_floor():
		current_flight_time = 0
	if Input.is_action_just_released("ui_accept"):
		flying = true
	if Input.is_action_pressed("ui_accept") and !is_on_floor() and current_flight_time < flight_time and flying:
		velocity.y = flight_velocity
		current_flight_time += delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
