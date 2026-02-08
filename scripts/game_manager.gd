extends Node

# TODO: this will handle logic for spawn points, timers, anything game related

## Time remaining to deliver the current letter. Rate of change increases as the
## game progresses.
var patience : float = 30
var timing : bool = false
var score : int = 0
@export var gaming : bool = false:
	set(val):
		gaming = val
		new_route()

var curr_queen : StaticBody3D
var curr_suitors : Array[StaticBody3D]

@export var queen_template : PackedScene
@export var suitor_template : PackedScene

var queen_spawns : Array[Node3D]
var suitor_spawns : Array[Node3D] # not used

## Adds given spawnpoint Node3D into pool.
func add_spawn(spawnpoint : Node3D):
	if spawnpoint.type == spawnpoint.Type.QUEEN:
		queen_spawns.append(spawnpoint)
	elif spawnpoint.type == spawnpoint.Type.SUITOR:
		suitor_spawns.append(spawnpoint)

func game_over():
	gaming = false
	GUI.flash_game_over()

## Spawns a queen and a few suitors, removing the old ones. This crashes if 
## there are no spawnpoints in the arrays!
func new_route():
	if not gaming: return
	timing = true
	print("generating new route")
	for spawn in queen_spawns:
		spawn.occupied = false
	# TODO: these queue_frees() should actually be calls to something like
	# fly_away() on the actors.
	if curr_queen:
		curr_queen.queue_free()
	curr_queen = queen_template.instantiate()
	get_tree().root.add_child(curr_queen)
	# TODO: do not include last spawn in the picking
	var fresh_spawn = queen_spawns.pick_random()
	while fresh_spawn.occupied:
		print("occupied, rerolling")
		fresh_spawn = queen_spawns.pick_random()
	fresh_spawn.occupied = true
	curr_queen.position = fresh_spawn.position
	print("made queen at ", curr_queen.position, curr_queen.get_parent())
	
	for suitor in curr_suitors:
		suitor.queue_free()
	curr_suitors.clear()
	for i in 3:
		var new : StaticBody3D = suitor_template.instantiate()
		get_tree().root.add_child(new)
		curr_suitors.append(new)
		fresh_spawn = queen_spawns.pick_random()
		while fresh_spawn.occupied:
			print("occupied, rerolling")
			fresh_spawn = queen_spawns.pick_random()
		fresh_spawn.occupied = true
		# TODO: made this the queen array so they both can yuse it
		new.position = fresh_spawn.position
		print("made suitor at ", new.position)

func _process(delta: float) -> void:
	if not timing or not gaming: return
	patience -= delta
	if patience <= 0:
		patience = 0
		game_over()
	GUI.update_patience(patience)
