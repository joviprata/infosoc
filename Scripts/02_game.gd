extends Control

@export var roundPages : Array[PageResource]

@onready var pause_button = $CanvasLayer/PauseButton as Button
@onready var resume_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/voltar as Button
@onready var return_menu_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/voltar_menu as Button
@onready var options_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/opcoes as Button
@onready var exit_menu_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/sair as Button
@onready var toggle_fullscreen = $CanvasLayer/OptionsPanel/MarginContainer/HBoxContainer/VBoxContainer/Toggle_Fullscreen as Button
@onready var toggle_volume = $CanvasLayer/OptionsPanel/MarginContainer/HBoxContainer/VBoxContainer/Toggle_Volume as Button
@onready var return_button = $CanvasLayer/OptionsPanel/MarginContainer/HBoxContainer/VBoxContainer/Return as Button

@onready var mini_page = $MiniPageMask/MiniPage as TextureRect
@onready var page = $Page as PageObject

@onready var mini_page_sound_1 = $MiniPageSound1
@onready var mini_page_sound_2 = $MiniPageSound2
@onready var mini_page_sound_3 = $MiniPageSound3
@onready var page_sound_1 = $PageSound1
@onready var page_sound_2 = $PageSound2
@onready var page_sound_3 = $PageSound3

@onready var random_character: RandomCharacter = $RandomCharacter

var wrongPages : Array[PageObject]

var can_stamp : bool = false

signal received_page(pageRes : PageResource)
signal returned_page(pageRes : PageResource)

func _ready() -> void:
	AudioController.start_inside_ambience_sound()
	
	for button in [pause_button, resume_button, return_menu_button, options_button, exit_menu_button, toggle_fullscreen, toggle_volume, return_button]:
		button.button_down.connect(ButtonSounds.play_button_down_sound)
		button.pressed.connect(ButtonSounds.play_button_up_sound)
	
	begin_round()

func begin_round() -> void:
	receive_page()
	await received_page
	can_stamp = true

func next_page() -> void:
	can_stamp = false
	return_page()
	await returned_page
	await get_tree().create_timer(1).timeout
	begin_round()

func end_game() -> void:
	pass

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
	var bus_index = AudioServer.get_bus_index("Master")
	var is_muted = AudioServer.is_bus_mute(bus_index)
	AudioServer.set_bus_mute(bus_index, !is_muted)

func _on_toggle_fullscreen_toggled(toggled_on: bool) -> void:
	var current_mode = DisplayServer.window_get_mode()
	var is_fullscreen = current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN

	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)



func _on_test_button_receber_pagina_pressed() -> void:
	receive_page()


func _on_test_button_entregar_pagina_pressed() -> void:
	return_page()
	
# When you receive the page
func receive_page() -> void:
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

	var start_position_page = Vector2(727, -200)
	var end_position_page = Vector2(727, 223)
	var duration_page = 0.4
	
	# Animate the mini page and SETS the Page Resource
	page.position = start_position_page
	page.set_page_resource(roundPages.pick_random())
	
	var tween_page := create_tween()
	tween_page.tween_property(page, "position", end_position_page, duration_page).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	random_character.on_page_given()
	
	await tween_page.finished
	
	received_page.emit(page.page_resource)
	
# Return the page to the Character
func return_page() -> void:
	# Play a random sound from the 3 options
	var sounds_page = [mini_page_sound_1, mini_page_sound_2, mini_page_sound_3]
	var random_sound_page = sounds_page[randi() % sounds_page.size()]
	random_sound_page.play()

	var start_position_page = Vector2(727, 223)
	var end_position_page = Vector2(727, -200)
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
	
	random_character.on_page_received()
	
	await tween_mini_page.finished && tween_page.finished
	
	returned_page.emit(page.page_resource)


# WHEN WE STAMP A PAGE
func stamp(is_approved : bool) -> void:
	
	# You APPROVED a page that was wrong!
	if page.page_resource.isWrong && is_approved == true:
		wrongPages.append(page)
	elif !page.page_resource.isWrong && is_approved == false:
		wrongPages.append(page)
		
	# Everytime we stamp a page, we go to the next_page and can't stamp until the next page appears
	
	next_page()
	

func _on_denied_stamp_on_stamped(is_approved: bool) -> void:
	if !can_stamp:
		return
		
	stamp(is_approved)


func _on_approved_stamp_on_stamped(is_approved: bool) -> void:
	if !can_stamp:
		return
		
	stamp(is_approved)
