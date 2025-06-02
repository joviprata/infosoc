@tool
class_name PageResource extends Resource

@export_group("Page Properties")
@export_multiline var title : String = "Insert Title of Page"
@export_multiline var software_desc : String = "Software Description"
@export_multiline var software_context_desc : String = "Context of use and implications"
@export_multiline var management_desc : String = "How the software will hold up"
@export_multiline var workplace_desc : String = "Workplace ambient"

@export_group("Key Sentences")
@export var sentences : Array[PageSentence]
