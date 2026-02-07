extends Control

func update_flight(new: float):
	new = snappedf(1.0 - new, 0.1)
	var out : String = "FLIGHT: " + str(new)
	$MarginContainer/FlightRemaining.text = out
