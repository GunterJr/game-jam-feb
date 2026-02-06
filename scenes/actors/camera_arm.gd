extends SpringArm3D

@export var mouse_sensitivity: float = 0.01
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_vert: float = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var max_vert: float = PI/4

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clamp(rotation.x, min_vert, max_vert)
