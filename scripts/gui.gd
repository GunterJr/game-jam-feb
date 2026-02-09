extends Control

@onready var flight_remaining: Label = $MarginContainer/VBoxContainer/FlightRemaining
@onready var letter_status: Label = $MarginContainer/VBoxContainer/LetterStatus
@onready var flight_bar: ProgressBar = $MarginContainer/VBoxContainer/FlightBar
@onready var patience_left: Label = $MarginContainer/VBoxContainer/PatienceLeft
@onready var game_over: Label = $CenterContainer/GameOver
@onready var letters_label: Label = $MarginContainer2/VBoxContainer/LettersLabel
@onready var score_label: Label = $MarginContainer2/VBoxContainer/ScoreLabel
@onready var letter: RichTextLabel = $MarginContainer3/LetterSprite/LetterLabel
@onready var letter_sprite: AnimatedSprite2D = $MarginContainer3/LetterSprite

var letters_delivered : int = 0;
var num_letters : int = 0:
	set(input):
		num_letters = input
		letters_label.text = "Letters Delivered: " + str(letters_delivered)
		letter_label(input)
		if num_letters >= 1: show_letter()
		else: close_letter()
		
func show_letter():
	if num_letters > 1:
		letter.text = GameManager.held_letters.back().contents
		$open.play()
		return
	letter_sprite.visible = true
	$open.play()
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(letter_sprite, "position", Vector2(-84.0, 0.0), 0.5)
	tween.tween_callback(letter_sprite.play.bind("open"))
	await letter_sprite.animation_finished
	letter.text = GameManager.held_letters.back().contents

func close_letter():
	letter.text = ""
	if GameManager.gaming:
		$close.play()
	var tween : Tween = get_tree().create_tween()
	tween.tween_callback(letter_sprite.play.bind("close"))
	await letter_sprite.animation_finished
	tween = get_tree().create_tween()
	tween.tween_property(letter_sprite, "position", Vector2(450.0, 0.0), 0.5)
	await tween.finished
	letter_sprite.visible = false

func update_score(new: int):
	score_label.text = "Score: " + str(new)

func update_patience(new: float):
	new = roundf(new)
	var out : String = "Queen's Patience: " + str(new)
	patience_left.text = out

func update_flight(new: float):
	new = snappedf(new, 0.1)
	var out : String = "FLIGHT: " + str(new)
	flight_remaining.text = out
	flight_bar.value = new
	
func letter_label(letter : int) -> void:
	if letter:
		letter_status.text = "Holding Letter x" + str(letter)
		letter_status.add_theme_color_override("font_color", Color(0.0, 0.808, 0.0, 1.0))
	else:
		letter_status.text = "No Letters!"
		letter_status.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))

func flash_game_over():
	for i : int in 5:
		await get_tree().create_timer(0.5).timeout
		game_over.visible = true
		await get_tree().create_timer(0.5).timeout
		game_over.visible = false
