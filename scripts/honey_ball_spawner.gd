extends StaticBody3D

@export var honey_ball : PackedScene
@export var spawning : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn()


func spawn():
	while spawning:
		var new_ball = honey_ball.instantiate()
		self.get_parent().add_child.call_deferred(new_ball)
		new_ball.position = global_position
		new_ball.honey_type = new_ball.Type.FLOATER
		await get_tree().create_timer(randf_range(4, 7)).timeout
		if new_ball:
			new_ball.queue_free()
