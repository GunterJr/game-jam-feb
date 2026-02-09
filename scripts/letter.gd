class_name Letter
extends Node

## Contents of the letter, as a string.
var contents : String = ""
## Decides whether a Queen will like the letter or not. 0-5.
var quality : int = 0

## Set contents of letter based on quality.
func gen_contents() -> void:
	match quality:
		0:
			contents = "My queen, I cannot contain my excitement anymore! I love the way you snore in your sleep; I adore your stubby, puny wings! Please marry me right away!"
		1:
			contents = "Dearest queen, this nectar has got me wondering if you will be a busy bee tonight?"
		2:
			contents = "My beloved queen. My little bee self was wondering if you would be open for a date. Because queen, you're the bee's knees."
		3:
			contents = "Oh myeth queen. How my every waking moment is thy mind on you., would'th thy giveth me a chance'th?"
		4:
			contents = "My queen, I know you have seen me working around the pollen fields, why will you not talk to me? My wings buzz for you..."
		5:	
			contents = "Dear queen,\nYour crown glistens in the amber light of the hive,\nand as your antennae sway in the wind like stalks of wheat,\nyour commanding gaze pierces through my heart."
		_: 	contents = "My queen,\nHow did we get here?"
