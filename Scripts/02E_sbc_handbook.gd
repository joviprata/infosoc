@tool
class_name SBCHandbook
extends Node2D

const PAGE_COUNT := 8
const PAGE_PATH_TEMPLATE := "res://Assets/SBC Handbook Pages/SBC_Handbook_Page_%d.png"

@onready var page_texture: Sprite2D = $Page_Texture
@onready var next_button: Button = $NextPageButton
@onready var prev_button: Button = $PreviousPageButton
@onready var background_page = $BackgroundPage

@onready var principle_a = $Principle_A
@onready var principle_b = $Principle_B
@onready var principle_c = $Principle_C
@onready var principle_d = $Principle_D

@onready var turn_page_sound_1 = $TurnPageSound1
@onready var turn_page_sound_2 = $TurnPageSound2
@onready var turn_page_sound_3 = $TurnPageSound3

@onready var sounds_turn_page = [turn_page_sound_1, turn_page_sound_2, turn_page_sound_3]

@onready var principle_selected_sound = $PrincipleSelectedSound

# Stores selected principle button names per page
var selected_principles := {}

# Max total selected principles across all pages
const MAX_SELECTED := 5

var current_page := 1

var principle_buttons: Array[Button]

var handbook_interaction_enabled := false

# Mapeamento entre nomes dos botões e códigos dos princípios
var principle_mapping := {
	"Principle_A": "1.1",
	"Principle_B": "1.2", 
	"Principle_C": "1.3",
	"Principle_D": "1.4"
}

# Mapeamento dinâmico dos princípios por página
var page_principle_mapping := {
	2: {"Principle_A": "1.1", "Principle_B": "1.2", "Principle_C": "1.3", "Principle_D": "1.4"},
	3: {"Principle_A": "1.5", "Principle_B": "1.6", "Principle_C": "1.7", "Principle_D": "2.1"},
	4: {"Principle_A": "2.2", "Principle_B": "2.3", "Principle_C": "2.4", "Principle_D": "2.5"},
	5: {"Principle_A": "2.6", "Principle_B": "2.7", "Principle_C": "2.8", "Principle_D": "2.9"},
	6: {"Principle_A": "3.1", "Principle_B": "3.2", "Principle_C": "3.3", "Principle_D": "3.4"},
	7: {"Principle_A": "3.5", "Principle_B": "3.6", "Principle_C": "3.7", "Principle_D": "4.1"},
	8: {"Principle_A": "4.2", "Principle_B": "", "Principle_C": "", "Principle_D": ""}
}

signal selection_updated(selected_count: int)

func _ready() -> void:
	principle_buttons = [principle_a, principle_b, principle_c, principle_d]

	for button in principle_buttons:
		var stylebox := StyleBoxFlat.new()
		stylebox.bg_color = Color(1, 1, 1, 0)  # fully transparent
		
		stylebox.set_border_width(SIDE_LEFT, 0)
		stylebox.set_border_width(SIDE_RIGHT, 0)
		stylebox.set_border_width(SIDE_TOP, 0)
		stylebox.set_border_width(SIDE_BOTTOM, 0)

		button.add_theme_stylebox_override("normal", stylebox)
		button.add_theme_stylebox_override("hover", stylebox.duplicate())
		button.add_theme_stylebox_override("pressed", stylebox.duplicate())
		button.focus_mode = Control.FOCUS_NONE

		# Disconnect any existing connections (safe guard)
		#button.pressed.disconnect_all()
		button.pressed.connect(func():
			if button.visible and not button.disabled and handbook_interaction_enabled:
				on_button_selected(button)
		)

	update_page()  # ensure initial correct page and button states

func on_button_selected(button: Button) -> void:
	if not button.visible or button.disabled:
		return

	var button_name := button.name

	# Ensure page tracking
	if not selected_principles.has(current_page):
		selected_principles[current_page] = []

	var selected_on_page = selected_principles[current_page]

	var is_already_selected = selected_on_page.has(button_name)

	if is_already_selected:
		selected_on_page.erase(button_name)
	else:
		var total_selected = get_total_selected()
		if total_selected >= MAX_SELECTED:
			return  # Don't allow more than 4 total
		selected_on_page.append(button_name)

	# Play sound
	principle_selected_sound.play()

	# Update button visuals
	update_button_visual(button, not is_already_selected)
	
	selection_updated.emit(get_total_selected())

func get_total_selected() -> int:
	var count = 0
	for val in selected_principles.values():
		count += val.size()
	return count

func _on_next_page_button_pressed() -> void:
	if current_page < PAGE_COUNT:
		current_page += 1
		update_page()
		var random_sound_turn_page = sounds_turn_page[randi() % sounds_turn_page.size()]
		random_sound_turn_page.play()

func _on_previous_page_button_pressed() -> void:
	if current_page > 1:
		current_page -= 1
		update_page()
		var random_sound_turn_page = sounds_turn_page[randi() % sounds_turn_page.size()]
		random_sound_turn_page.play()

func update_page() -> void:
	var page_path := PAGE_PATH_TEMPLATE % current_page
	var page_texture_res := load(page_path)
	
	if page_texture_res:
		page_texture.texture = page_texture_res
	else:
		printerr("Failed to load page at: ", page_path)

	# Enable/disable navigation buttons based on current page
	prev_button.visible = current_page > 1
	prev_button.disabled = current_page == 1

	next_button.visible = current_page < PAGE_COUNT
	next_button.disabled = current_page == PAGE_COUNT

	# Colors for reset
	var selected_on_this_page: Array = selected_principles.get(current_page, [])

	for button in principle_buttons:
		var show_button := false

		if current_page == 1:
			show_button = false
		elif current_page == PAGE_COUNT:
			show_button = button == principle_a
		else:
			show_button = true

		button.visible = show_button
		button.disabled = not show_button

		# Update selection highlight based on stored selection
		var is_selected = selected_on_this_page.has(button.name)
		update_button_visual(button, is_selected)

	# Hide background page if this is the last page
	#background_page.visible = current_page != PAGE_COUNT

func update_button_visual(button: Button, is_selected: bool) -> void:
	var yellow = Color(1, 1, 0, 0.4)
	var transparent = Color(1, 1, 1, 0)

	var style_normal = button.get_theme_stylebox("normal", "Button") as StyleBoxFlat
	var style_hover = button.get_theme_stylebox("hover", "Button") as StyleBoxFlat
	var style_pressed = button.get_theme_stylebox("pressed", "Button") as StyleBoxFlat

	style_normal.bg_color = yellow if is_selected else transparent
	style_hover.bg_color = yellow if is_selected else transparent
	style_pressed.bg_color = yellow if is_selected else transparent

func clear_selection() -> void:
	selected_principles.clear()
	update_page()
	selection_updated.emit(0)

func get_selected_principles_for_validation() -> Array:
	var all_selected: Array = []
	print("=== DEBUG MAPEAMENTO DE PRINCÍPIOS ===")
	print("Princípios selecionados por página: ", selected_principles)
	
	for page_num in selected_principles.keys():
		var page_principles = selected_principles[page_num]
		var page_mapping = page_principle_mapping.get(page_num, principle_mapping)
		
		print("Página ", page_num, " - Botões selecionados: ", page_principles)
		print("Página ", page_num, " - Mapeamento: ", page_mapping)
		
		for button_name in page_principles:
			if page_mapping.has(button_name) and page_mapping[button_name] != "":
				var principle_code = page_mapping[button_name]
				all_selected.append(principle_code)
				print("  Mapeado: ", button_name, " -> ", principle_code)
			else:
				print("  ERRO: Não foi possível mapear ", button_name)
	
	print("Total de princípios mapeados: ", all_selected)
	print("=====================================")
	return all_selected
