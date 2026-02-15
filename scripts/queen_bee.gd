extends StaticBody3D

@onready var voice: Label3D = $Voice
@onready var deliver_trigger: Area3D = $DeliverTrigger
@onready var talker: AudioStreamPlayer3D = $Talker

## Emitted when letter(s) have been delivered to the Queen.
signal letters_recieved()

# TODO: These are hardcoded in for now, though if we have time we ought to
# write to json
var comments : Array[String] = [
	"Thank you, drone.",
	"Another dissapointing gift?",
	"Very well, I'll put it with the rest.",
	"Ugh... When will they learn?"
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

func on_player_enter(_body: Node3D) -> void:
	if GameManager.held_letters.is_empty(): # this is not okay
		speak("Shouldn't you ~bee~ doing something?")
		return
	print("Letter sent!")
	
	letters_recieved.emit()
	
	var phrase : String = comments[randi_range(0, comments.size() - 1)]
	# TODO: scrolling text
	speak(phrase)
	# next 4 bad
	GameManager.cash_out()
	GameManager.patience += GameManager.patience_gained
	await get_tree().create_timer(2).timeout
	GameManager.new_route()

func letter_delivered():
	pass
