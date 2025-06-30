@tool
class_name PageObject 
extends Node2D

@export var page_resource : PageResource

@onready var page_sprite = $Page_Sprite
@onready var stamp_mask = $StampMask as TextureRect

var is_wrong : bool
signal on_page_changed(page_number : int)

var approvedTexture = load("res://Assets/APPROVED.png")
var deniedTexture = load("res://Assets/DENIED.png")

var stampPos : Vector2

var seen_pages: Array[int] = []
var last_page_number: int = -1  # So we know what was shown last
var current_page_number: int = -1  # Número da página atual para validação

# Format: { page_number: [is_valid, [principles broken if is not valid] }
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

func show_random_page() -> void:
	var keys = page_data.keys()
	
	# Filter out pages that have already been seen
	var unseen_keys = keys.filter(func(key): return not seen_pages.has(key))
	
	# If all pages have been seen, reset the list
	if unseen_keys.is_empty():
		#print("Seen pages list reset.")
		seen_pages.clear()
		unseen_keys = keys.duplicate()

	# Avoid selecting the same page as last time
	var valid_keys = unseen_keys.filter(func(k): return k != last_page_number)
	if valid_keys.is_empty():
		valid_keys = unseen_keys.duplicate()  # fallback if only 1 page exists

	var random_key = valid_keys[randi() % valid_keys.size()]
	last_page_number = random_key
	current_page_number = random_key  # Definir o número da página atual
	seen_pages.append(random_key)
	
	var metadata = page_data[random_key]

	# Load image and apply
	var image_path = "res://Assets/Case Pages/Case_Page_%d.png" % random_key
	var tex = load(image_path)
	page_sprite.texture = tex

	is_wrong = not metadata[0]
	on_page_changed.emit(random_key)


func _on_approved_stamp_on_dropped(body: CharacterBody2D, pos: Vector2) -> void:
	var ap = Sprite2D.new()
	ap.texture = approvedTexture
	stamp_mask.add_child(ap)
	ap.global_position = pos + Vector2(0, 90)
	stampPos = ap.global_position - Vector2(600, 90)


func _on_denied_stamp_on_dropped(body: CharacterBody2D, pos: Vector2) -> void:
	var ap = Sprite2D.new()
	ap.texture = deniedTexture
	stamp_mask.add_child(ap)
	ap.global_position = pos + Vector2(0, 79)
	stampPos = ap.global_position - Vector2(600, 79)


func _ready() -> void:
	if not Engine.is_editor_hint():
		show_random_page()
