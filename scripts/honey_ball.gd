extends Area3D

enum Type {FLOATER, REGROWER}
@export var honey_type : Type

func _physics_process(delta: float) -> void:
	if honey_type == Type.FLOATER:
		position.y += .05

func _on_body_entered(body: Node3D) -> void:
	body.refresh()
	if honey_type == Type.FLOATER:
		queue_free()
	elif honey_type == Type.REGROWER: # redundant but readable
		$CollisionShape3D.set_deferred("disabled", true)
		visible = false
		$Timer.start()
	
## Calls when a Regrower type HoneyBall's regrow timer triggers.
func _on_regrow() -> void:
	visible = true
	$CollisionShape3D.disabled = false
