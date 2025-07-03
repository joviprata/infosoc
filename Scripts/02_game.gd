extends Control

@export var roundPages : Array[PageResource]

@export var level_timer: Timer
@onready var fade_rect = $CanvasLayer/FadeRect as ColorRect

@onready var pause_button = $CanvasLayer/PauseButton as TextureButton
@onready var resume_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/voltar as Button
@onready var return_menu_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/voltar_menu as Button
@onready var options_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/opcoes as Button
@onready var exit_menu_button = $CanvasLayer/Panel/MarginContainer/HBoxContainer/VBoxContainer/sair as Button
@onready var toggle_fullscreen = $CanvasLayer/OptionsPanel/MarginContainer/HBoxContainer/VBoxContainer/Toggle_Fullscreen as Button
@onready var toggle_volume = $CanvasLayer/OptionsPanel/MarginContainer/HBoxContainer/VBoxContainer/Toggle_Volume as Button
@onready var return_button = $CanvasLayer/OptionsPanel/MarginContainer/HBoxContainer/VBoxContainer/Return as Button
@onready var sbc_handbook_button = $CanvasLayer/SBCHandbookButton as TextureButton
@onready var sbc_handbook = $SBC_Handbook
@onready var validate_denied_button = $ValidateDeniedButton

@onready var approved_stamp = $ApprovedStamp
@onready var denied_stamp = $DeniedStamp
@onready var validate_denied_text = $Validate_Denied_Text

@onready var mini_page = $MiniPageMask/MiniPage as TextureRect
@onready var page = $Page as PageObject

@onready var mini_page_sound_1 = $MiniPageSound1
@onready var mini_page_sound_2 = $MiniPageSound2
@onready var mini_page_sound_3 = $MiniPageSound3
@onready var page_sound_1 = $PageSound1
@onready var page_sound_2 = $PageSound2
@onready var page_sound_3 = $PageSound3
@onready var text_reveal_sound = $TextRevealSound

@onready var random_character: RandomCharacter = $RandomCharacter

var wrongPages : Array[PageObject]

var can_stamp : bool = false

# Dados das páginas para validação de princípios
var page_data := {
	1: [false, ["1.1", "1.2", "1.3", "1.5", "1.6", "2.3", "2.5", "4.1", "4.2"]],
	2: [true],
	3: [false, ["1.1", "1.2", "1.4", "1.6", "3.3", "3.4", "4.1", "4.2"]],
	4: [false, ["1.3", "1.4", "2.5", "3.5", "3.7", "4.1", "4.2"]],
	5: [false, ["1.1", "1.2", "1.4", "2.8", "2.9", "3.2", "4.1", "4.2"]],
	6: [true],
	7: [true],
	8: [true]
}

signal received_page(pageRes : PageResource)
signal returned_page(pageRes : PageResource)

func _ready() -> void:
	AudioController.start_inside_ambience_sound()
	
	# Resetar pontuação no início do jogo
	Global.reset_score()
	
	for button in [pause_button, resume_button, return_menu_button, options_button, exit_menu_button, toggle_fullscreen, toggle_volume, return_button, sbc_handbook_button, validate_denied_button]:
		button.button_down.connect(ButtonSounds.play_button_down_sound)
		button.pressed.connect(ButtonSounds.play_button_up_sound)

	approved_stamp.stamp_drag_started.connect(_on_stamp_drag_started)
	denied_stamp.stamp_drag_started.connect(_on_stamp_drag_started)
	
	begin_round()
	fade_rect.modulate = Color("#39314b", 0.0)
	
	sbc_handbook.selection_updated.connect(_on_selection_updated)
	validate_denied_button.disabled = true

func begin_round() -> void:
	player_receives_page()
	await received_page
	can_stamp = true

func next_page() -> void:
	can_stamp = false
	player_returns_page()
	await returned_page
	await get_tree().create_timer(1).timeout
	begin_round()

func end_game() -> void:
	pass

func _on_pause_button_pressed() -> void:
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
	# Step 1: Disable all interaction
	can_stamp = false
	#get_tree().paused = true  # Freezes gameplay (unless animations use physics)
	
	await get_tree().create_timer(1).timeout
	
	# Step 2: Start fade-to-black animation
	var target_color := Color("#39314b")
	target_color.a = 1.0  # fully opaque
	
	var tween := create_tween()
	tween.tween_property(fade_rect, "modulate", target_color, 1.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
	# Step 3: Wait fade + pause time
	await get_tree().create_timer(1.8).timeout
	
	# Step 4: Load results scene
	#get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/03_game_results.tscn")


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
	player_receives_page()


func _on_test_button_entregar_pagina_pressed() -> void:
	player_returns_page()
	
# When you receive the page
func player_receives_page() -> void:
	random_character.on_player_receives_page()
	
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
	var end_position_page = Vector2(727, 221)
	var duration_page = 0.4
	
	# Animate the mini page and SETS the Page Resource
	page.position = start_position_page
	page.show_random_page()
	
	var tween_page := create_tween()
	tween_page.tween_property(page, "position", end_position_page, duration_page).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	
	await tween_page.finished
	
	received_page.emit(page.page_resource)
	
# Return the page to the Character
func player_returns_page() -> void:
	# Play a random sound from the 3 options
	var sounds_page = [mini_page_sound_1, mini_page_sound_2, mini_page_sound_3]
	var random_sound_page = sounds_page[randi() % sounds_page.size()]
	random_sound_page.play()

	var start_position_page = Vector2(727, 221)
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
	
	random_character.on_player_gives_page()
	
	#await tween_mini_page.finished && tween_page.finished
	await get_tree().create_timer(2.2).timeout
	
	returned_page.emit(page.page_resource)
	
	#Limpar carimbos 1 segundo depois da página sair
	await get_tree().create_timer(1.0).timeout
	for child in page.stamp_mask.get_children():
		child.queue_free()
		
	sbc_handbook.handbook_interaction_enabled = false
	validate_denied_button.visible = false
	validate_denied_button.disabled = true


# WHEN WE STAMP A PAGE
func stamp(is_approved : bool) -> void:
	var selected_principles = []
	
	if page.is_wrong and is_approved:
		wrongPages.append(page)
	elif !page.is_wrong and !is_approved:
		wrongPages.append(page)
	else:
		# Página foi carimbada corretamente
		if is_approved:
			Global.add_score_for_correct_approval()
		else:
			Global.add_score_for_correct_denial()

	if !is_approved:
		approved_stamp.can_interact = false
		denied_stamp.can_interact = false
		# 1. Move the page to (632, 244)
		var tween_page := create_tween()
		tween_page.tween_property(page, "position", Vector2(632, 244), 0.7)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

		# 2. Slide in the handbook (enable)
		if !sbc_handbook_button.button_pressed:
			await get_tree().create_timer(0.5).timeout
			sbc_handbook_button.button_pressed = true
			# toggled signal will handle animation
		sbc_handbook_button.disabled = true  # 3. Disable interaction

		# 4. Move stamps to Y = 608
		var tween_approved := create_tween()
		tween_approved.tween_property(approved_stamp, "position:y", 608, 0.7)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

		var tween_denied := create_tween()
		tween_denied.tween_property(denied_stamp, "position:y", 618, 0.7)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		await get_tree().create_timer(0.4).timeout
		
		text_reveal_sound.play()
		validate_denied_text.visible = true
		validate_denied_button.visible = true
		validate_denied_button.disabled = true  # Start disabled

		# Enable principle button interaction
		sbc_handbook.handbook_interaction_enabled = true
		
		# NÃO salvar a página aqui - será salva após a validação

		return # Exit early, skip next_page()

	# Salvar a página carimbada (apenas páginas aprovadas ou negadas sem validação)
	print("Salvando página: ", page.current_page_number, " | Aprovada: ", is_approved, " | Posição: ", page.stampPos)
	Global.add_stamped_page(page.current_page_number, is_approved, page.stampPos, [], page.is_wrong)

	next_page()
	
	sbc_handbook.handbook_interaction_enabled = false
	validate_denied_button.visible = false
	validate_denied_button.disabled = true


	

func _on_denied_stamp_on_stamped(is_approved: bool) -> void:
	if !can_stamp:
		return

	stamp(is_approved)

	# --- Snatch the approved stamp if it's being dragged ---
	if approved_stamp.is_dragging():  # <-- you need to implement or check this
		approved_stamp.release_drag()  # <-- custom method or behavior, see note below
	
	await get_tree().create_timer(0.7).timeout
	
	var tween := create_tween()
	tween.tween_property(approved_stamp, "position:y", 608, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_approved_stamp_on_stamped(is_approved: bool) -> void:
	if !can_stamp:
		return
		
	stamp(is_approved)


func toggle_handbook_visibility(toggled_on: bool) -> void:
	var target_position := Vector2(872, 255) if toggled_on else Vector2(1071, 255)

	# Play a random page slide sound
	var sounds_page = [page_sound_1, page_sound_2, page_sound_3]
	var random_sound = sounds_page[randi() % sounds_page.size()]
	random_sound.play()

	# Animate the slide
	var tween := create_tween()
	tween.tween_property(sbc_handbook, "position", target_position, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
func _on_sbc_handbook_button_toggled(toggled_on: bool) -> void:
	toggle_handbook_visibility(toggled_on)
	
func _on_stamp_drag_started() -> void:
	if sbc_handbook_button.button_pressed:
		sbc_handbook_button.button_pressed = false


func _on_validate_denied_button_pressed() -> void:
	can_stamp = false

	# Obter os princípios selecionados pelo jogador
	var selected_principles = sbc_handbook.get_selected_principles_for_validation()
	
	# Verificar se os princípios selecionados estão corretos
	if page.is_wrong:
		var correct_principles = page_data[page.current_page_number][1] if page.current_page_number in page_data else []
		
		print("=== DEBUG VALIDAÇÃO DE PRINCÍPIOS ===")
		print("Página atual: ", page.current_page_number)
		print("Princípios corretos para esta página: ", correct_principles)
		print("Princípios selecionados pelo jogador: ", selected_principles)
		print("Total de princípios selecionados: ", selected_principles.size())
		
		# Contar quantos princípios foram selecionados corretamente
		var correct_selections = 0
		for principle in selected_principles:
			if principle in correct_principles:
				correct_selections += 1
				print("✓ Princípio correto: ", principle)
			else:
				print("✗ Princípio incorreto: ", principle)
		
		print("Total de princípios corretos: ", correct_selections)
		
		# Adicionar pontuação pelos princípios corretos
		if correct_selections > 0:
			Global.add_score_for_correct_principles(correct_selections)
			print("Pontuação adicionada pelos princípios: ", correct_selections * Global.SCORE_CORRECT_PRINCIPLE)
		print("=====================================")

	# Salvar a página com os princípios selecionados
	print("=== SALVANDO PÁGINA APÓS VALIDAÇÃO ===")
	print("Página: ", page.current_page_number, " | Aprovada: ", false, " | Posição: ", page.stampPos)
	print("Princípios selecionados: ", selected_principles)
	Global.add_stamped_page(page.current_page_number, false, page.stampPos, selected_principles, page.is_wrong)

	# 1. Tween page back to normal reading position
	var tween_page := create_tween()
	tween_page.tween_property(page, "position", Vector2(727, 221), 0.7)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# 2. Tween stamps back to original position
	var tween_approved := create_tween()
	tween_approved.tween_property(approved_stamp, "position", Vector2(601, 459), 0.7)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	var tween_denied := create_tween()
	tween_denied.tween_property(denied_stamp, "position", Vector2(839, 470), 0.7)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	approved_stamp.can_interact = true
	denied_stamp.can_interact = true

	# 3. Hide handbook (simulate toggle off)
	if sbc_handbook_button.button_pressed:
		sbc_handbook_button.button_pressed = false

	sbc_handbook_button.disabled = false

	# 4. Instantly hide button & text
	validate_denied_button.visible = false
	validate_denied_text.visible = false

	# 5. Disable handbook interaction
	sbc_handbook.handbook_interaction_enabled = false

	# 6. Wait 0.4s, then clear the handbook selection
	await get_tree().create_timer(0.4).timeout
	sbc_handbook.clear_selection()

	# 7. Wait for tweens to finish
	await tween_page.finished

	# 8. Return the page and wait for it to finish
	player_returns_page()
	await returned_page

	# 9. Start next round
	await get_tree().create_timer(1).timeout
	begin_round()



	
func _on_selection_updated(selected_count: int) -> void:
	# Only respond if validation button is supposed to be shown
	if validate_denied_button.visible:
		validate_denied_button.disabled = selected_count == 0
