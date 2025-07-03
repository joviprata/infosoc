class_name RandomCharacter
extends Node2D

@onready var character_animation := $CharacterAnimation
@onready var walk_in_sound = $WalkinSound
@onready var walk_out_sound = $WalkoutSound

var last_animation := ""
var seen_characters: Array[String] = []

const ALL_CHARACTERS := ["A", "B", "C", "D"]

func _ready():
	randomize()
	position = Vector2(-211, 232.5)

func _on_test_button_receber_pagina_pressed() -> void:
	on_player_receives_page()

func _on_test_button_entregar_pagina_pressed() -> void:
	on_player_gives_page()

func on_player_gives_page() -> void:
	walk_out_sound.play()
	await get_tree().create_timer(1).timeout

	var tween := create_tween()
	var duration = 1.2
	tween.tween_property(self, "position", Vector2(713, 232.5), duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func on_player_receives_page() -> void:
	walk_in_sound.play()
	position = Vector2(-211, 232.5)

	# Get available characters excluding seen ones and last_animation
	var available_characters := ALL_CHARACTERS.filter(func(char):
		return !seen_characters.has(char) and char != last_animation
	)

	# If no characters are left (only last_animation remains), reset seen_characters
	if available_characters.is_empty():
		seen_characters.clear()
		available_characters = ALL_CHARACTERS.filter(func(char):
			return char != last_animation
		)

	# Select a new animation
	var new_animation: String = available_characters[randi() % available_characters.size()]
	last_animation = new_animation
	seen_characters.append(new_animation)

	# Play animation
	character_animation.play(new_animation)

	# Tween into frame
	var tween := create_tween()
	var duration = 1.2
	tween.tween_property(self, "position", Vector2(251, 232.5), duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
