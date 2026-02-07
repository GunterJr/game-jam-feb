extends Node

# TODO: this will handle logic for spawn points, timers, anything game related

## Time remaining to deliver the current letter. Rate of change increases as the
## game progresses.
var patience : float = 30
var timing : bool = false
@export var gaming : bool = false:
	set(val):
		gaming = val
		new_route()

var curr_queen : StaticBody3D
var curr_suitor : StaticBody3D

@export var queen : PackedScene
@export var suitor : PackedScene

var queen_spawns : Array[Node3D]
var suitor_spawns : Array[Node3D]

## Adds given spawnpoint Node3D into pool.
func add_spawn(spawnpoint : Node3D):
	if spawnpoint.type == spawnpoint.Type.QUEEN:
		queen_spawns.append(spawnpoint)
	elif spawnpoint.type == spawnpoint.Type.SUITOR:
		suitor_spawns.append(spawnpoint)

func game_over():
	gaming = false
	GUI.flash_game_over()

## Spawns a queen and a suitor, removing the old ones. This crashes if there
## are no spawnpoints in the arrays!
func new_route():
	if not gaming: return
	timing = true
	print("generating new route")
	# TODO: these queue_frees() should actually be calls to something like
	# fly_away() on the actors.
	if curr_queen:
		curr_queen.queue_free()
	curr_queen = queen.instantiate()
	get_tree().root.add_child(curr_queen)
	# TODO: do not include last spawn in the picking
	curr_queen.position = queen_spawns.pick_random().position
	print("made queen at ", curr_queen.position, curr_queen.get_parent())
	
	if curr_suitor:
		curr_suitor.queue_free()
	curr_suitor = suitor.instantiate()
	get_tree().root.add_child(curr_suitor)
	# TODO: made this the queen array so they both can yuse it
	curr_suitor.position = queen_spawns.pick_random().position
	print("made suitor at ", curr_suitor.position)

func _process(delta: float) -> void:
	if not timing or not gaming: return
	patience -= delta
	if patience <= 0:
		patience = 0
		game_over()
	GUI.update_patience(patience)
