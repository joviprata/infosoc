extends Control

@onready var pause_button = $CanvasLayer/PauseButton as Button
@onready var resume_button = $CanvasLayer/Panel/MenuOpcoes/voltar as Button
@onready var return_menu_button = $CanvasLayer/Panel/MenuOpcoes/voltar_menu as Button
@onready var options_button = $CanvasLayer/Panel/MenuOpcoes/opcoes as Button
@onready var exit_menu_button = $CanvasLayer/Panel/MenuOpcoes/sair as Button


func _ready() -> void:
	AudioController.start_inside_ambience_sound()
	
	for button in [pause_button, resume_button, return_menu_button, options_button, exit_menu_button]:
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
	# Por enquanto apenas mostrar mensagem de desenvolvimento
	print("Em desenvolvimento")


func _on_sair_pressed() -> void:
	# Sair do jogo
	get_tree().quit()


func _on_level_timer_timeout() -> void:
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/01_main_menu.tscn")
