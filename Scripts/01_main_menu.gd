extends Control

@onready var play_button = $MarginContainer/HBoxContainer/VBoxContainer/Play_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var credits_button = $MarginContainer/HBoxContainer/VBoxContainer/Credits_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button

@onready var game_scene = "res://Scenes/02_game.tscn"
@onready var options_scene = "res://scenes/01A_menu_options.tscn"
@onready var credits_scene = "res://scenes/01B_menu_credits.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioController.start_menu_song()
	
	for button in [play_button, options_button, credits_button, exit_button]:
		button.button_down.connect(ButtonSounds.play_button_down_sound)
		button.pressed.connect(ButtonSounds.play_button_up_sound)
	
	play_button.pressed.connect(on_play_pressed)
	options_button.pressed.connect(on_options_pressed)
	credits_button.pressed.connect(on_credits_pressed)
	exit_button.pressed.connect(on_exit_pressed)

func on_play_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)

func on_options_pressed() -> void:
	get_tree().change_scene_to_file(options_scene)
	
func on_credits_pressed() -> void:
	get_tree().change_scene_to_file(credits_scene)
	
func on_exit_pressed() -> void:
	get_tree().quit()
