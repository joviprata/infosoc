class_name RoundResults extends Control


@export var finishedPages : Array[PageResource]
@onready var v_results: VBoxContainer = $ScrollContainer/V_Results

var numberOfFinishedPages

const PAGE_RESULT = preload("res://Scenes/page_result.tscn")

func _ready() -> void:
	for page in finishedPages:
		var instantiatedPage = PAGE_RESULT.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		v_results.add_child(instantiatedPage)
		
		instantiatedPage.set_page_resource(page)
