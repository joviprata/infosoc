@tool
class_name PageSentence extends Resource

@export_multiline var sentence : String

func _init() -> void:
	self.sentence = "Insira uma frase ou palavra que esteja correta ou não\n"
	

func check_if_exists(otherSentence : String) -> bool:
	return otherSentence.contains(sentence)
		
