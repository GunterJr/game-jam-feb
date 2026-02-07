extends Control

@onready var flight_remaining: Label = $MarginContainer/VBoxContainer/FlightRemaining
@onready var letter_status: Label = $MarginContainer/VBoxContainer/LetterStatus
@onready var flight_bar: ProgressBar = $MarginContainer/VBoxContainer/FlightBar
@onready var patience_left: Label = $MarginContainer/VBoxContainer/PatienceLeft
@onready var game_over: Label = $CenterContainer/GameOver

## Really, this should not be stored in a GUI singleton, it probably should be 
## some other autoload for game state. Oh well.
var has_letter : bool = false:
	set(input):
		has_letter = input
		letter_label(input)

func update_patience(new: float):
	new = roundf(new)
	var out : String = "Queen's Patience: " + str(new)
	patience_left.text = out

func update_flight(new: float):
	new = snappedf(new, 0.1)
	var out : String = "FLIGHT: " + str(new)
	flight_remaining.text = out
	flight_bar.value = new
	
func letter_label(letter : bool) -> void:
	if letter:
		letter_status.text = "Holding Letter!"
		letter_status.add_theme_color_override("font_color", Color(0.0, 0.808, 0.0, 1.0))
	else:
		letter_status.text = "No Letter"
		letter_status.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))

func flash_game_over():
	for i : int in 5:
		await get_tree().create_timer(0.5).timeout
		game_over.visible = true
		await get_tree().create_timer(0.5).timeout
		game_over.visible = false
