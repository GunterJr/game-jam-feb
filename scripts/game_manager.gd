extends Node

# TODO: this will handle logic for spawn points, timers, anything game related

## Time remaining to deliver the current letter in seconds. 
var patience : float = 40
var score : int = 0
## Letters that Benson currently has in his inventory to be delivered. 
var held_letters : Array[Letter]
## Decides whether the game loop is active or not. Calls new_route() on mutate.
@export var gaming : bool = false:
	set(val):
		gaming = val
		new_route()

var curr_queen : StaticBody3D
var curr_suitors : Array[StaticBody3D]

@export var queen_template : PackedScene = preload("res://scenes/actors/queen-bee.tscn")
@export var suitor_template : PackedScene = preload("res://scenes/actors/suitor-bee.tscn")
## Amount of suitors to spawn on a new route.
@export var suitors_to_spawn : int = 5
## Amount of patience delivering letters awards the player with.
@export var patience_gained : float = 30.0

var queen_spawns : Array[Node3D]
var suitor_spawns : Array[Node3D] # not used

func reset():
	if curr_queen:
		curr_queen.queue_free()
	for suitor in curr_suitors:
		suitor.queue_free()
	queen_spawns.clear()
	curr_queen = null
	curr_suitors.clear()
	held_letters.clear()
	patience = 30
	score = 0
	GUI.num_letters = 0
	GUI.update_patience(patience)
	GUI.update_score(score)

## Adds given spawnpoint Node3D into pool.
func add_spawn(spawnpoint : Node3D):
	if spawnpoint.type == spawnpoint.Type.QUEEN:
		queen_spawns.append(spawnpoint)
	elif spawnpoint.type == spawnpoint.Type.SUITOR:
		suitor_spawns.append(spawnpoint)

func game_over():
	gaming = false
	GUI.flash_game_over()
	await get_tree().create_timer(5).timeout
	reset()
	get_tree().change_scene_to_file("res://scenes/areas/main-menu.tscn")

## Spawns a queen and a few suitors, removing the old ones. This crashes if 
## there are no spawnpoints in the arrays!
func new_route():
	if not gaming: return
	if queen_spawns.size() == 0:
		print("Fatal: There are no available queen spawns. Cancelling gameloop.")
		gaming = false
		return
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
	for i in suitors_to_spawn:
		var new : StaticBody3D = suitor_template.instantiate()
		get_tree().root.add_child(new)
		curr_suitors.append(new)
		fresh_spawn = queen_spawns.pick_random()
		while fresh_spawn.occupied:
			print("occupied, rerolling")
			fresh_spawn = queen_spawns.pick_random()
		fresh_spawn.occupied = true
		# FIXME: made this the queen array so they both can yuse it
		new.position = fresh_spawn.position
		print("made suitor at ", new.position)

## Adds value of each letter to the score, multiplied by the amount held. Clears
## held_letters and updates GUI accordingly.
func cash_out():
	for letter : Letter in held_letters:
		score += letter.quality * held_letters.size()
	GUI.update_score(score)
	GUI.letters_delivered += GameManager.held_letters.size()
	GUI.num_letters = 0
	held_letters.clear()
	
func _process(delta: float) -> void:
	if not gaming: return
	patience -= delta
	if patience <= 0:
		patience = 0
		game_over()
	GUI.update_patience(patience)
