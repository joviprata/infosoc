extends Control

@onready var toggle_fullscreen = $MarginContainer/HBoxContainer/VBoxContainer/Toggle_Fullscreen as Button
@onready var toggle_volume = $MarginContainer/HBoxContainer/VBoxContainer/Toggle_Volume as Button
@onready var return_to_menu = $MarginContainer/HBoxContainer/VBoxContainer/Return_to_Menu

@onready var menu_scene = "res://Scenes/01_main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioController.start_menu_song()
	
	for button in [toggle_fullscreen, toggle_volume, return_to_menu]:
		button.button_down.connect(ButtonSounds.play_button_down_sound)
		button.pressed.connect(ButtonSounds.play_button_up_sound)
	
	toggle_volume.toggled.connect(_on_toggle_volume_toggled)
	toggle_fullscreen.toggled.connect(_on_toggle_fullscreen_toggled)

func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file(menu_scene)

func _on_toggle_volume_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

func _on_toggle_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
