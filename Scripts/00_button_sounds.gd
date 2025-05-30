extends Node2D

@onready var button_down_sound = $Button_Down_Sound
@onready var button_up_sound = $Button_Up_Sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func play_button_down_sound():
	button_down_sound.play()
	
func play_button_up_sound():
	button_up_sound.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
