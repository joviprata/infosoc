class_name RandomCharacter extends Node2D

@onready var character_animation := $CharacterAnimation
var last_animation = ""

@onready var walk_in_sound = $WalkinSound
@onready var walk_out_sound = $WalkoutSound


func _ready():
	randomize()
	#play_random_animation()
	
	# Initial off-screen position
	position = Vector2(-211, 232.5)

#func play_random_animation():
	#var animations = ["A", "B", "C", "D"]
	#var new_animation = last_animation
	#
	## Loop until a different animation is selected
	#while new_animation == last_animation:
		#new_animation = animations[randi() % animations.size()]
	#
	#last_animation = new_animation
	#$CharacterAnimation.play(new_animation)


func _on_test_button_receber_pagina_pressed() -> void:
	on_page_given()
	

func _on_test_button_entregar_pagina_pressed() -> void:
	on_page_received()
	
func on_page_received() -> void:
	# Wait for character to get back his paper
	await get_tree().create_timer(0.5).timeout
	
	# Play walk-out sound
	walk_out_sound.play()
	await get_tree().create_timer(1).timeout
	# Tween the character out of the frame
	var tween := create_tween()
	var duration = 1.2
	tween.tween_property(self, "position", Vector2(713, 232.5), duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func on_page_given() -> void:
	# Play walk-in sound
	walk_in_sound.play()
	
	# Reset to start position BEFORE tweening
	position = Vector2(-211, 232.5)

	# Pick a random animation different from the last one
	var animations = ["A", "B", "C", "D"]
	var new_animation = last_animation
	while new_animation == last_animation:
		new_animation = animations[randi() % animations.size()]
	last_animation = new_animation

	# Play the animation
	character_animation.play(new_animation)
	
	# Tween the character into the frame
	var tween := create_tween()
	var duration = 1.2
	tween.tween_property(self, "position", Vector2(251, 232.5), duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
