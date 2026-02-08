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
			contents = "My queen,\nI cannot contain my excitement anymore!\n
						I love the way you snore in your sleep; I adore your\n
						stubby, puny wings! Please marry me right away!"
		_: 	contents = "My queen,\nHow did we get here?"
