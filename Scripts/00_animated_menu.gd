extends TextureRect

# Preload both textures
var frame1 = preload("res://Assets/Menu Screen Frame 1.png")
var frame2 = preload("res://Assets/Menu Screen Frame 2.png")

var current_frame = 0

func _ready():
	texture = frame1  # Start with the first frame

func _on_timer_timeout() -> void:
	current_frame = 1 - current_frame  # Toggle between 0 and 1
	texture = frame1 if current_frame == 0 else frame2
