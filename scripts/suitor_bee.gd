extends StaticBody3D

@onready var voice: Label3D = $Voice
@onready var collect_trigger: Area3D = $CollectTrigger
## TODO: These are hardcoded in for now, though if we have time we ought to
##
var comments : Array[String] = [
	"Please send this to my one true love!",
	"Have you seen the Queen? Please deliver this!",
	"See that this gets through safely...",
	"Ohhh.... The Queen..."
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	voice.text = ""

func on_player_enter(body: Node3D) -> void:
	print("Letter get!")
	voice.text = comments[randi_range(0, comments.size() - 1)]
	# TODO: scrolling text
	$CollectTrigger/CollisionShape3D.set_deferred("disabled", true)
	GUI.has_letter = true
