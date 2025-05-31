extends Control

@onready var pause_button = $CanvasLayer/PauseButton as Button
@onready var resume_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/voltar as Button
@onready var return_menu_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/voltar_menu as Button
@onready var options_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/opcoes as Button
@onready var exit_menu_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/sair as Button
@onready var toggle_fullscreen = $CanvasLayer/OptionsPanel/MarginContainer/HBoxContainer/VBoxContainer/Toggle_Fullscreen as Button
@onready var toggle_volume = $CanvasLayer/OptionsPanel/MarginContainer/HBoxContainer/VBoxContainer/Toggle_Volume as Button
@onready var return_button = $CanvasLayer/OptionsPanel/MarginContainer/HBoxContainer/VBoxContainer/Return as Button

@onready var mini_page = $MiniPageMask/MiniPage as TextureRect
@onready var page = $"Page (depois mudar para cena Page)" as TextureRect

@onready var mini_page_sound_1 = $MiniPageSound1
@onready var mini_page_sound_2 = $MiniPageSound2
@onready var mini_page_sound_3 = $MiniPageSound3
@onready var page_sound_1 = $PageSound1
@onready var page_sound_2 = $PageSound2
@onready var page_sound_3 = $PageSound3

func _ready() -> void:
	AudioController.start_inside_ambience_sound()
	
	for button in [pause_button, resume_button, return_menu_button, options_button, exit_menu_button, toggle_fullscreen, toggle_volume, return_button]:
		button.button_down.connect(ButtonSounds.play_button_down_sound)
		button.pressed.connect(ButtonSounds.play_button_up_sound)


func _on_menu_de_opcoes_pressed() -> void:
	# Abrir o layout de menu_de_opcoes (VBoxContainer)
	$CanvasLayer/Panel.visible = true

func _on_voltar_pressed() -> void:
	get_tree().paused = false
	# Voltar para o jogo, fechar o VBoxContainer
	$CanvasLayer/Panel.visible = false


func _on_voltar_menu_pressed() -> void:
	# Voltar para o menu do jogo
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/01_main_menu.tscn")


func _on_opcoes_pressed() -> void:
	$CanvasLayer/Panel.visible = false
	$CanvasLayer/OptionsPanel.visible = true


func _on_sair_pressed() -> void:
	# Sair do jogo
	get_tree().quit()


func _on_level_timer_timeout() -> void:
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/01_main_menu.tscn")


func _on_return_pressed() -> void:
	$CanvasLayer/Panel.visible = true
	$CanvasLayer/OptionsPanel.visible = false


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


func _on_test_button_receber_pagina_pressed() -> void:
		# Wait for character walk in
	await get_tree().create_timer(1.8).timeout
	
	# Play a random sound from the 3 options
	var sounds_mini_page = [mini_page_sound_1, mini_page_sound_2, mini_page_sound_3]
	var random_sound_mini_page = sounds_mini_page[randi() % sounds_mini_page.size()]
	random_sound_mini_page.play()
	
	var start_position_mini_page = Vector2(-48, -312)
	var end_position_mini_page = Vector2(-48, -102)
	var duration_mini_page = 0.3
	
	# Animate the mini page
	mini_page.position = start_position_mini_page
	var tween_mini_page := create_tween()
	tween_mini_page.tween_property(mini_page, "position", end_position_mini_page, duration_mini_page).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	

	await get_tree().create_timer(0.5).timeout
	
	# Play a random sound from the 3 options
	var sounds_page = [page_sound_1, page_sound_2, page_sound_3]
	var random_sound_page = sounds_page[randi() % sounds_page.size()]
	random_sound_page.play()

	var start_position_page = Vector2(579, -396)
	var end_position_page = Vector2(579, 27)
	var duration_page = 0.4
	
	# Animate the mini page
	page.position = start_position_page
	var tween_page := create_tween()
	tween_page.tween_property(page, "position", end_position_page, duration_page).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_test_button_entregar_pagina_pressed() -> void:
	# Play a random sound from the 3 options
	var sounds_page = [mini_page_sound_1, mini_page_sound_2, mini_page_sound_3]
	var random_sound_page = sounds_page[randi() % sounds_page.size()]
	random_sound_page.play()

	var start_position_page = Vector2(579, 27)
	var end_position_page = Vector2(579, -396)
	var duration_page = 0.4
	
	# Animate the mini page
	page.position = start_position_page
	var tween_page := create_tween()
	tween_page.tween_property(page, "position", end_position_page, duration_page).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	await get_tree().create_timer(0.5).timeout

	# Play a random sound from the 3 options
	var sounds_mini_page = [page_sound_1, page_sound_2, page_sound_3]
	var random_sound_mini_page = sounds_mini_page[randi() % sounds_mini_page.size()]
	random_sound_mini_page.play()
	
	var start_position_mini_page = Vector2(-48, -102)
	var end_position_mini_page = Vector2(-48, -312)
	var duration_mini_page = 0.3
	
	# Animate the mini page
	mini_page.position = start_position_mini_page
	var tween_mini_page := create_tween()
	tween_mini_page.tween_property(mini_page, "position", end_position_mini_page, duration_mini_page).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
