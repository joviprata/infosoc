extends Control

@onready var play_button = $MarginContainer/HBoxContainer/VBoxContainer/Play_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button

@onready var game_scene = "res://Scenes/02_game.tscn"
@onready var options_scene = "res://scenes/01_options.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioController.start_menu_song()
	
	play_button.button_down.connect(on_play_pressed)
	options_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)

func on_play_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)

func on_options_pressed() -> void:
	get_tree().change_scene_to_file(options_scene)
	
func on_exit_pressed() -> void:
	get_tree().quit()
