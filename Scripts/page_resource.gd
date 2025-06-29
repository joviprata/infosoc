@tool
class_name PageResource extends Resource

# In order to create the mistakes, we're going to Highlight them by
# using a custom BB Code Marker named [wrong "_sbcDirective"][/wrong] that highlights
# the sentence that is wrong based on a directive from the SBC Document

# Example: [wrong "3"]"We got a chamber here"[/wrong] 

@export_group("Page Properties")
@export_multiline var title : String = "Insert Title of Page"
@export_multiline var software_desc : String = "Software Description"
@export_multiline var software_context_desc : String = "Context of use and implications"
@export_multiline var management_desc : String = "How the software will hold up"
@export_multiline var workplace_desc : String = "Workplace ambient"

@export_group("")
@export var isWrong : bool

# Each wrong sentence needs to be part of one of the areas below
# The Keys are IMMUTABLE and should follow the default order setted
@export var wrongSentences : Dictionary[String,String] = {
	'workplace' : 'Wrong sentence from workplace',
	'soft_desc' : 'Wrong sentence from description',
	'soft_context' : 'Wrong sentence from context',
	'management' : 'Wrong sentence from management'
}

# Put each key of the violated SBC on this DataStructure (Example: 1.1, 1.2, 1.3, 1.4
@export var sbc_violated_directives : Array[String]

var stampPos : Vector2

func get_all_texts() -> String:
	return title + '\n' + software_desc + '\n' + software_context_desc + '\n' + management_desc + '\n' + workplace_desc


			
