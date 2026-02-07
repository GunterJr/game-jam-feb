extends Control

func update_flight(new: float):
	new = snappedf(new, 0.1)
	var out : String = "FLIGHT: " + str(new)
	$MarginContainer/FlightRemaining.text = out
