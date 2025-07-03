extends Control

@onready var return_to_menu = $MarginContainer/HBoxContainer/VBoxContainer/Return_to_Menu

@onready var menu_scene = "res://Scenes/01_main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioController.start_menu_song()
	
	for button in [return_to_menu]:
		button.button_down.connect(ButtonSounds.play_button_down_sound)
		button.pressed.connect(ButtonSounds.play_button_up_sound)
	
	return_to_menu.pressed.connect(_on_return_to_menu_pressed)

func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file(menu_scene)
