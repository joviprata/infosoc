extends Timer

@onready var label = $"../Time_Left"
@onready var timer = $"."
@onready var time_up_sound = $"../TimeUpSound"

var time_up_sound_played := false  # Flag to track if sound has been played

func _ready() -> void:
	label.text = "3:00"

func _process(delta: float) -> void:
	if !timer.is_stopped():
		var minutes = int(timer.time_left / 60)
		var seconds = int(timer.time_left) % 60

		var sec_str = str(seconds)
		if seconds < 10:
			sec_str = "0" + sec_str

		label.text = str(minutes) + ":" + sec_str

		# Play sound when 2 second or less remains, only once
		if timer.time_left <= 2.0 and !time_up_sound_played:
			time_up_sound.play()
			time_up_sound_played = true

func _on_level_start_countdown_timeout() -> void:
	timer.start()
	time_up_sound_played = false  # Reset flag when timer restarts
