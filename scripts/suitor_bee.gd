extends StaticBody3D

@onready var voice: Label3D = $Voice
@onready var collect_trigger: Area3D = $CollectTrigger
@onready var talker: AudioStreamPlayer3D = $Talker
@export var accessories : Array[MeshInstance3D]

## Emitted when a letter has been constructed and given to the player by the
## suitor. Contains the given [Letter] in the [param letter] argument.
signal shipped_letter(letter : Letter)

## TODO: These are hardcoded in for now, though if we have time we ought to
##
var comments : Array[String] = [
	"Please send this to my one true love!",
	"Have you seen the Queen? Please deliver this!",
	"See that this gets through safely...",
	"Ohhh.... The Queen..."
]

# Called when the node enters the scene tree for the first t  ime.
func _ready() -> void:
	voice.text = ""
	accessories.pick_random().visible = true
	
## Sets the Voice label to the phrase, then clears it after 5s.
func speak(phrase : String):
	voice.text = phrase
	# Play cute noises
	for i : int in 5:
		talker.play()
		await talker.finished
	await get_tree().create_timer(5).timeout
	voice.text = ""

func on_player_enter(_body: Node3D) -> void:
	print("Letter get!")
	# The following four lines handle making a new letter,
	# these could probably happen in the Letter class as well
	var new_letter : Letter = Letter.new()
	new_letter.quality = randi_range(0, 5)
	new_letter.gen_contents()
	var phrase : String = comments[randi_range(0, comments.size() - 1)]
	
	shipped_letter.emit(new_letter)
	GameManager.held_letters.append(new_letter) # problematic
	GUI.num_letters += 1 # problematic
	# TODO: scrolling text
	$CollectTrigger/CollisionShape3D.set_deferred("disabled", true)
	speak(phrase)
