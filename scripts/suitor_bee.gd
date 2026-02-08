extends StaticBody3D

@onready var voice: Label3D = $Voice
@onready var collect_trigger: Area3D = $CollectTrigger
@onready var talker: AudioStreamPlayer3D = $Talker
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
	
## Sets the Voice label to the phrase, then clears it after 5s.
func speak(phrase : String):
	voice.text = phrase
	# Play cute noises
	for i : int in 5:
		talker.play()
		await talker.finished
	await get_tree().create_timer(5).timeout
	voice.text = ""

func on_player_enter(body: Node3D) -> void:
	if GUI.has_letter:
		speak("You look like you have a letter already!")
		return
	print("Letter get!")
	var phrase : String = comments[randi_range(0, comments.size() - 1)]
	speak(phrase)
	# TODO: scrolling text
	$CollectTrigger/CollisionShape3D.set_deferred("disabled", true)
	GUI.has_letter = true
	
