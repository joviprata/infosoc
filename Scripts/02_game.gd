extends Control
func _ready() -> void:
	AudioController.start_inside_ambience_sound()


func _on_menu_de_opcoes_pressed() -> void:
	# Abrir o layout de menu_de_opcoes (VBoxContainer)
	$CanvasLayer/Panel.visible = true

func _on_voltar_pressed() -> void:
	# Voltar para o jogo, fechar o VBoxContainer
	$CanvasLayer/Panel.visible = false


func _on_voltar_menu_pressed() -> void:
	# Voltar para o menu do jogo
	get_tree().change_scene_to_file("res://Scenes/01_main_menu.tscn")


func _on_opcoes_pressed() -> void:
	# Por enquanto apenas mostrar mensagem de desenvolvimento
	print("Em desenvolvimento")


func _on_sair_pressed() -> void:
	# Sair do jogo
	get_tree().quit()
