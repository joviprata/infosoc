extends TextureButton

func _on_pressed() -> void:
	disabled = true
	get_tree().paused = true

func _on_voltar_pressed() -> void:
	disabled = false
	get_tree().paused = false
