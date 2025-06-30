extends Control

@onready var game_scene = "res://Scenes/02_game.tscn"
@onready var menu_scene = "res://scenes/01_main_menu.tscn"

@onready var page_results = $ScrollContainer/MarginContainer/Page_Results

var approvedTexture = load("res://Assets/APPROVED.png")
var deniedTexture = load("res://Assets/DENIED.png")
var pixelifyFont = load("res://Assets/Fonts/PixelifySans-VariableFont_wght.ttf")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioController.start_menu_song()
	
	# Centralizar o conteúdo
	page_results.alignment = BoxContainer.ALIGNMENT_CENTER
	
	# Adicionar título RESULTADO
	add_result_title()
	
	# Mostrar todas as páginas carimbadas
	show_all_stamped_pages()
	
	# Adicionar pontuação final no final
	add_final_score_display()
	
	# Adicionar botões no final
	add_buttons_at_end()


func add_result_title() -> void:
	# Título RESULTADO
	var result_title = RichTextLabel.new()
	result_title.bbcode_enabled = true
	result_title.text = "[center]RESULTADO:[/center]"
	result_title.custom_minimum_size = Vector2(0, 50)
	result_title.add_theme_font_override("normal_font", pixelifyFont)
	result_title.add_theme_font_size_override("normal_font_size", 32)
	page_results.add_child(result_title)
	
	# Adicionar separador
	var separator = HSeparator.new()
	separator.custom_minimum_size = Vector2(0, 20)
	page_results.add_child(separator)

func show_all_stamped_pages() -> void:
	print("=== EXIBINDO PÁGINAS CARIMBADAS ===")
	print("Total de páginas salvas: ", Global.stampedPages.size())
	for i in range(Global.stampedPages.size()):
		var page = Global.stampedPages[i]
		print("Página %d: Número=%d, Aprovada=%s, Posição=%s" % [i, page.page_number, page.stampType, page.stampPos])
	
	for page in Global.stampedPages:
		create_page_result_display(page)

func add_final_score_display() -> void:
	# Adicionar separador antes da pontuação final
	var separator = HSeparator.new()
	separator.custom_minimum_size = Vector2(0, 20)
	page_results.add_child(separator)
	
	# Container para a pontuação final
	var final_score_container = VBoxContainer.new()
	final_score_container.custom_minimum_size = Vector2(0, 200)
	final_score_container.alignment = BoxContainer.ALIGNMENT_CENTER
	
	# Título da pontuação final
	var final_score_title = RichTextLabel.new()
	final_score_title.bbcode_enabled = true
	final_score_title.text = "[center]PONTUAÇÃO FINAL[/center]"
	final_score_title.custom_minimum_size = Vector2(0, 40)
	final_score_title.add_theme_font_override("normal_font", pixelifyFont)
	final_score_title.add_theme_font_size_override("normal_font_size", 32)
	final_score_container.add_child(final_score_title)
	
	# Pontuação total
	var total_score_label = RichTextLabel.new()
	total_score_label.bbcode_enabled = true
	total_score_label.text = "[center]%d pontos[/center]" % Global.current_score
	total_score_label.custom_minimum_size = Vector2(0, 60)
	total_score_label.add_theme_font_override("normal_font", pixelifyFont)
	total_score_label.add_theme_font_size_override("normal_font_size", 32)
	final_score_container.add_child(total_score_label)
	
	# Estatísticas detalhadas
	var stats_label = RichTextLabel.new()
	stats_label.bbcode_enabled = true
	stats_label.text += "• Páginas aprovadas corretamente: %d (+%d pontos)\n" % [Global.correctly_approved_pages, Global.correctly_approved_pages * Global.SCORE_CORRECT_APPROVAL]
	stats_label.text += "• Páginas negadas corretamente: %d (+%d pontos)\n" % [Global.correctly_denied_pages, Global.correctly_denied_pages * Global.SCORE_CORRECT_DENIAL]
	stats_label.text += "• Princípios selecionados corretamente: %d (+%d pontos)\n" % [Global.correctly_selected_principles, Global.correctly_selected_principles * Global.SCORE_CORRECT_PRINCIPLE]
	stats_label.text += "• Total de páginas avaliadas: %d" % Global.total_pages_processed
	stats_label.custom_minimum_size = Vector2(0, 120)
	stats_label.add_theme_font_override("normal_font", pixelifyFont)
	stats_label.add_theme_font_size_override("normal_font_size", 18)
	final_score_container.add_child(stats_label)
	
	# Adicionar ao container de resultados
	page_results.add_child(final_score_container)

func create_page_result_display(page_data) -> void:
	# Container principal para cada página
	var page_container = HBoxContainer.new()
	page_container.custom_minimum_size = Vector2(0, 400)
	page_container.add_theme_constant_override("separation", 20)
	page_container.alignment = BoxContainer.ALIGNMENT_CENTER
	
	# Lado esquerdo - Imagem da página com carimbo
	var left_side = VBoxContainer.new()
	left_side.custom_minimum_size = Vector2(300, 0)
	left_side.alignment = BoxContainer.ALIGNMENT_CENTER
	
	# Container para a imagem da página com clipping
	var page_image_container = TextureRect.new()
	page_image_container.custom_minimum_size = Vector2(280, 350)
	page_image_container.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# Carregar a imagem da página baseada no número
	var page_image = load_page_image(page_data.page_number)
	if page_image:
		page_image_container.texture = page_image
	
	# Criar StampMask para clipping (similar ao Paper.tscn)
	var stamp_mask = TextureRect.new()
	stamp_mask.clip_children = 1
	stamp_mask.offset_left = -10  # Área muito pequena para testar clipping
	stamp_mask.offset_top = -10   # Área muito pequena para testar clipping
	stamp_mask.offset_right = 10
	stamp_mask.offset_bottom = 10
	stamp_mask.texture = load("res://Assets/Page.png")
	stamp_mask.position = Vector2(140, 175)  # Centralizar no container
	
	# Adicionar carimbo na posição correta dentro do StampMask
	var stamp = create_stamp(page_data.stampType, page_data.stampPos)
	stamp_mask.add_child(stamp)
	
	page_image_container.add_child(stamp_mask)
	
	left_side.add_child(page_image_container)
	
	# Lado direito - Informações da página
	var right_side = VBoxContainer.new()
	right_side.custom_minimum_size = Vector2(400, 0)
	right_side.alignment = BoxContainer.ALIGNMENT_CENTER
	
	# Resposta correta
	var correct_answer_label = RichTextLabel.new()
	correct_answer_label.bbcode_enabled = true
	correct_answer_label.text = "Resposta Correta:\n"
	correct_answer_label.text += "[color=green]APROVADO[/color]" if not page_data.is_wrong else "[color=red]NEGADO[/color]"
	correct_answer_label.custom_minimum_size = Vector2(0, 60)
	correct_answer_label.add_theme_font_override("normal_font", pixelifyFont)
	correct_answer_label.add_theme_font_size_override("normal_font_size", 18)
	right_side.add_child(correct_answer_label)
	
	# Princípios violados (se a página for inválida)
	if page_data.is_wrong:
		var violated_principles_label = RichTextLabel.new()
		violated_principles_label.bbcode_enabled = true
		violated_principles_label.text = "Princípios Violados:\n"
		
		var correct_principles = get_correct_principles_for_page_number(page_data.page_number)
		# Ordenar princípios alfabeticamente
		correct_principles.sort()
		
		for principle in correct_principles:
			var directive_text = "%s - %s\n" % [principle, Global.SBC_DIRECTIVES[principle]]
			violated_principles_label.text += directive_text
		
		violated_principles_label.custom_minimum_size = Vector2(0, 120)
		violated_principles_label.add_theme_font_override("normal_font", pixelifyFont)
		violated_principles_label.add_theme_font_size_override("normal_font_size", 18)
		right_side.add_child(violated_principles_label)
	
	# Resposta do jogador
	var player_answer_label = RichTextLabel.new()
	player_answer_label.bbcode_enabled = true
	player_answer_label.text = "Sua Resposta:\n"
	player_answer_label.text += "[color=green]APROVADO[/color]" if page_data.stampType else "[color=red]NEGADO[/color]"
	player_answer_label.custom_minimum_size = Vector2(0, 60)
	player_answer_label.add_theme_font_override("normal_font", pixelifyFont)
	player_answer_label.add_theme_font_size_override("normal_font_size", 18)
	right_side.add_child(player_answer_label)
	
	# Princípios selecionados pelo jogador (se negou)
	if not page_data.stampType and page_data.selected_principles.size() > 0:
		var selected_principles_label = RichTextLabel.new()
		selected_principles_label.bbcode_enabled = true
		selected_principles_label.text = "Princípios Selecionados:\n"
		
		# Ordenar princípios alfabeticamente
		var sorted_principles = page_data.selected_principles.duplicate()
		sorted_principles.sort()
		
		for principle in sorted_principles:
			selected_principles_label.text += "• " + principle + "\n"
		
		selected_principles_label.custom_minimum_size = Vector2(0, 80)
		selected_principles_label.add_theme_font_override("normal_font", pixelifyFont)
		selected_principles_label.add_theme_font_size_override("normal_font_size", 18)
		right_side.add_child(selected_principles_label)
	
	# Pontuação ganha nesta página
	var page_score_label = RichTextLabel.new()
	page_score_label.bbcode_enabled = true
	page_score_label.text = "Pontuação Ganha:\n"
	
	var page_score = calculate_page_score(page_data)
	page_score_label.text += "+%d pontos" % page_score
	page_score_label.custom_minimum_size = Vector2(0, 60)
	page_score_label.add_theme_font_override("normal_font", pixelifyFont)
	page_score_label.add_theme_font_size_override("normal_font_size", 18)
	right_side.add_child(page_score_label)
	
	# Adicionar lados ao container principal
	page_container.add_child(left_side)
	page_container.add_child(right_side)
	
	# Adicionar separador
	var separator = HSeparator.new()
	separator.custom_minimum_size = Vector2(0, 10)
	
	# Adicionar ao container de resultados
	page_results.add_child(page_container)
	page_results.add_child(separator)

func load_page_image(page_number: int) -> Texture2D:
	# Carregar imagem baseada no número da página
	var image_path = "res://Assets/Case Pages/Case_Page_%d.png" % page_number
	return load(image_path)

func create_stamp(is_approved: bool, stamp_pos: Vector2) -> Sprite2D:
	var stamp = Sprite2D.new()
	stamp.texture = approvedTexture if is_approved else deniedTexture
	stamp.z_index = 100
	
	# Converter a posição do carimbo para coordenadas relativas ao StampMask
	# No page_object.gd, a posição é calculada como:
	# stampPos = ap.global_position - Vector2(600, 90) ou Vector2(600, 79)
	# 
	# Para converter de volta para posição relativa ao StampMask:
	var offset = Vector2(600, 90) if is_approved else Vector2(600, 79)
	var global_pos = stamp_pos + offset
	var page_pos = Vector2(727, 221)  # Posição do PageObject no jogo
	var relative_pos = global_pos - page_pos
	
	# Mapear da posição relativa ao PageObject para o StampMask
	# StampMask: 280x350 pixels (de -140 a 140 em X, de -175 a 175 em Y)
	# 
	# Converter coordenadas do StampMask original para o novo StampMask
	var original_stamp_mask_size = Vector2(296, 392)  # 148*2, 196*2
	var new_stamp_mask_size = Vector2(280, 350)
	
	# Normalizar a posição relativa (0-1)
	var normalized_x = (relative_pos.x + 148) / original_stamp_mask_size.x
	var normalized_y = (relative_pos.y + 196) / original_stamp_mask_size.y
	
	# Aplicar ao novo StampMask
	var adjusted_pos = Vector2(
		normalized_x * new_stamp_mask_size.x - new_stamp_mask_size.x/2,
		normalized_y * new_stamp_mask_size.y - new_stamp_mask_size.y/2
	)
	
	stamp.position = adjusted_pos
	stamp.self_modulate.a = 0.8
	
	print("Carimbo criado - Tipo: %s, Posição original: %s, Posição ajustada: %s" % ["APROVADO" if is_approved else "NEGADO", stamp_pos, adjusted_pos])
	
	return stamp

func calculate_page_score(page_data) -> int:
	var score = 0
	
	# Verificar se a resposta está correta (aprovado/negado)
	var correct_answer = not page_data.is_wrong  # true = deveria ser aprovado, false = deveria ser negado
	var player_answer = page_data.stampType  # true = jogador aprovou, false = jogador negou
	
	if correct_answer == player_answer:
		# Resposta correta - +10 pontos
		score += 10
		print("✓ Resposta correta: +10 pontos")
	else:
		# Resposta incorreta - 0 pontos
		print("✗ Resposta incorreta: +0 pontos")
	
	# Adicionar pontuação pelos princípios corretos (apenas se a página for inválida E foi negada corretamente)
	if page_data.is_wrong and not player_answer:  # Página é inválida e jogador negou corretamente
		var correct_principles = get_correct_principles_for_page_number(page_data.page_number)
		var correct_selections = 0
		for principle in page_data.selected_principles:
			if principle in correct_principles:
				correct_selections += 1
				print("✓ Princípio correto: %s (+2 pontos)" % principle)
			else:
				print("✗ Princípio incorreto: %s (+0 pontos)" % principle)
		
		score += correct_selections * 2
		print("Total de princípios corretos: %d (+%d pontos)" % [correct_selections, correct_selections * 2])
	
	print("Pontuação total da página: %d pontos" % score)
	return score

func get_correct_principles_for_page_number(page_number: int) -> Array:
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
	
	if page_data.has(page_number) and page_data[page_number].size() > 1:
		return page_data[page_number][1]
	
	return []

func add_buttons_at_end() -> void:
	# Adicionar separador antes dos botões
	var separator = HSeparator.new()
	separator.custom_minimum_size = Vector2(0, 20)
	page_results.add_child(separator)
	
	# Container para os botões
	var buttons_container = VBoxContainer.new()
	buttons_container.custom_minimum_size = Vector2(0, 120)
	buttons_container.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons_container.add_theme_constant_override("separation", 18)
	
	# Criar botões dinamicamente
	var play_again_button = Button.new()
	play_again_button.text = "JOGAR NOVAMENTE"
	play_again_button.custom_minimum_size = Vector2(200, 50)
	play_again_button.add_theme_font_override("font", pixelifyFont)
	play_again_button.add_theme_font_size_override("font_size", 30)
	
	var menu_button = Button.new()
	menu_button.text = "VOLTAR AO MENU"
	menu_button.custom_minimum_size = Vector2(200, 50)
	menu_button.add_theme_font_override("font", pixelifyFont)
	menu_button.add_theme_font_size_override("font_size", 30)
	
	# Adicionar botões ao container
	buttons_container.add_child(play_again_button)
	buttons_container.add_child(menu_button)
	
	# Adicionar ao container de resultados
	page_results.add_child(buttons_container)
	
	# Conectar sinais dos botões (apenas uma vez)
	for button in [play_again_button, menu_button]:
		button.button_down.connect(ButtonSounds.play_button_down_sound)
		button.pressed.connect(ButtonSounds.play_button_up_sound)
	
	# Conectar funções específicas
	play_again_button.pressed.connect(on_play_again_pressed)
	menu_button.pressed.connect(on_menu_pressed)

func on_play_again_pressed() -> void:
	Global.reset_score()
	Global.clear_stamped_pages()
	get_tree().change_scene_to_file(game_scene)

func on_menu_pressed() -> void:
	Global.reset_score()
	Global.clear_stamped_pages()
	get_tree().change_scene_to_file(menu_scene)
