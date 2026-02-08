extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GUI.visible = false

## Starts the game.
func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/areas/new - zone.tscn")
