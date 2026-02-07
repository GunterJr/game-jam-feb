extends Node3D

enum Type {
	QUEEN,
	SUITOR
}
@export var type : Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.add_spawn(self)
