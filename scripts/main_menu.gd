extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GUI.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GameManager.set_script(null)

## Starts the game.
func _on_start_game_pressed() -> void:
	GameManager.set_script(load("res://scripts/game_manager.gd"))
	get_tree().change_scene_to_file("res://scenes/areas/new - zone.tscn")


func _on_exit_pressed() -> void:
	%AudioStreamPlayer.play()
	await %AudioStreamPlayer.finished
	get_tree().quit()
