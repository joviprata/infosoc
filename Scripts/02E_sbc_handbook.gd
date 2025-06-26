@tool
class_name SBCHandbook
extends Node2D

const PAGE_COUNT := 8
const PAGE_PATH_TEMPLATE := "res://Assets/SBC Handbook Pages/SBC_Handbook_Page_%d.png"

@onready var page_texture: Sprite2D = $Page_Texture
@onready var next_button: Button = $NextPageButton
@onready var prev_button: Button = $PreviousPageButton
@onready var background_page = $BackgroundPage

@onready var turn_page_sound_1 = $TurnPageSound1
@onready var turn_page_sound_2 = $TurnPageSound2
@onready var turn_page_sound_3 = $TurnPageSound3

@onready var sounds_turn_page = [turn_page_sound_1, turn_page_sound_2, turn_page_sound_3]

var current_page := 1

func _ready() -> void:
	update_page()

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
	
	# Hide background page if this is the last page
	#background_page.visible = current_page != PAGE_COUNT
