class_name PageResult extends Control

@export var page_resource : PageResource

@onready var title: RichTextLabel = $PageDescriptions/Title
@onready var software_description: RichTextLabel = $PageDescriptions/SoftwareDescription
@onready var software_management: RichTextLabel = $PageDescriptions/SoftwareManagement
@onready var context_and_usage: RichTextLabel = $PageDescriptions/ContextAndUsage
@onready var workplace_description: RichTextLabel = $PageDescriptions/WorkplaceDescription

@onready var correct_or_not_label: RichTextLabel = $CorrectOrNotLabel
@onready var violated_directives_label: RichTextLabel = $ViolatedDirectivesLabel


func set_page_resource(pageRes : PageResource) -> void:
	page_resource = pageRes
	
	title.text = pageRes.title + " ™"
	software_description.text = "Descrição do Software:\n" + pageRes.software_desc
	software_management.text = "Como o software irá se manter:\n" + pageRes.management_desc
	
	context_and_usage.text = "Contexto de uso e implicações:\n" + pageRes.software_context_desc
	
	workplace_description.text = "Ambiente de trabalho: \n" + pageRes.workplace_desc
	
	correct_or_not_label.text = "[color=green]CORRETO[/color]" if !pageRes.isWrong else '[color=red]ERRADO[/color]'
	
	violated_directives_label.text = 'Diretrizes violadas:\n'
	if pageRes.isWrong:
		for directive in pageRes.sbc_violated_directives:
			var text = "{0} - {1}\n".format({'0':directive,'1':Global.SBC_DIRECTIVES[directive]})
			violated_directives_label.text += text
	else:
		violated_directives_label.text = "[color=green]Este projeto segue todas as diretrizes[/color]"

	
func set_wrong_sentences() -> void:
	var allText = page_resource.get_all_texts()

	for textArea in page_resource.wrongSentences.keys():
		var val = page_resource.wrongSentences[textArea]
		
		var splited_sentence = val.split(',')
		
		for sentence in splited_sentence:
			if sentence not in allText:
				print(sentence + ' not in text')
				continue
				
			var newText = '[color=red]' + sentence + '[/color]'
			
			match textArea:
				'workplace':
					workplace_description.text = workplace_description.text.replace(sentence,newText)
				'soft_desc':
					software_description.text = software_description.text.replace(sentence,newText)
				'soft_context':
					context_and_usage.text = context_and_usage.text.replace(sentence,newText)
				'management':
					software_management.text = software_management.text.replace(sentence,newText)
			
		
