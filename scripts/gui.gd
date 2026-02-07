extends Control

@onready var flight_remaining: Label = $MarginContainer/VBoxContainer/FlightRemaining
@onready var letter_status: Label = $MarginContainer/VBoxContainer/LetterStatus

## Really, this should not be stored in a GUI singleton, it probably should be 
## some other autoload for game state. Oh well.
var has_letter : bool = false:
	set(input):
		letter_label(input)

func update_flight(new: float):
	new = snappedf(new, 0.1)
	var out : String = "FLIGHT: " + str(new)
	flight_remaining.text = out
	
func letter_label(letter : bool) -> void:
	if letter:
		letter_status.text = "Holding Letter!"
		letter_status.add_theme_color_override("font_color", Color(0.0, 0.808, 0.0, 1.0))
	else:
		letter_status.text = "No Letter"
		letter_status.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))
