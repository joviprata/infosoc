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

@export var wrongSentences : Array[String]

func get_all_texts() -> String:
	return title + '\n' + software_desc + '\n' + software_context_desc + '\n' + management_desc + '\n' + workplace_desc
	
