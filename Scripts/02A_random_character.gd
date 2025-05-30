extends Node2D

var last_animation = ""

func _ready():
	randomize()
	play_random_animation()

func play_random_animation():
	var animations = ["A", "B", "C", "D"]
	var new_animation = last_animation
	
	# Loop until a different animation is selected
	while new_animation == last_animation:
		new_animation = animations[randi() % animations.size()]
	
	last_animation = new_animation
	$CharacterAnimation.play(new_animation)
