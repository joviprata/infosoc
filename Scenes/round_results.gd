class_name RoundResults extends Control

@onready var v_results: VBoxContainer = $ScrollContainer/V_Results

var numberOfFinishedPages

const PAGE_RESULT = preload("res://Scenes/page_result.tscn")

var approvedTexture = load("res://Assets/APPROVED.png")
var deniedTexture = load("res://Assets/DENIED.png")

func _ready() -> void:
	show_stamped_pages()
	show_current_score()

func show_current_score() -> void:
	# Criar um label para mostrar a pontuação atual
	var score_label = Label.new()
	score_label.text = "Pontuação Atual: %d" % Global.current_score
	score_label.add_theme_font_size_override("font_size", 24)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v_results.add_child(score_label)
	
	# Adicionar um separador
	var separator = HSeparator.new()
	v_results.add_child(separator)
		

func _on_next_round_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/02_game.tscn")
	Global.stampedPages.clear()

func show_stamped_pages() -> void:
	for page in Global.stampedPages:
		var instantiatedPage = PAGE_RESULT.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		v_results.add_child(instantiatedPage)
		
		instantiatedPage.set_page_resource(page.page_resource)
		instantiatedPage.set_wrong_sentences()
		
		# Instantiate the Stamp on the Instantiated Page
		if page.stampType:
			instantiatedPage.stamp_mask.add_child(instantiate_approved_stamp(page.stampPos))
		else:
			instantiatedPage.stamp_mask.add_child(instantiate_denied_stamp(page.stampPos))
		

func instantiate_approved_stamp(stampPos : Vector2) -> Sprite2D:
	var ap = Sprite2D.new()
	ap.texture = approvedTexture
	ap.z_index = 100
	ap.position = stampPos
	ap.self_modulate.a = .35
	return ap
	
func instantiate_denied_stamp(stampPos:Vector2) -> Sprite2D:
	var ap = Sprite2D.new()
	ap.texture = deniedTexture
	ap.z_index = 100
	ap.position = stampPos
	ap.self_modulate.a = .35
	return ap
