@tool
class_name PageObject extends Node2D

@export var page_resource : PageResource

@export_group("Page Descriptions")
@export var titleLabel : RichTextLabel
@export var softwareLabel : RichTextLabel
@export var managementLabel : RichTextLabel
@export var contextAndUsageLabel : RichTextLabel
@export var workplaceLabel : RichTextLabel

@onready var area_2d: Area2D = $Area2D

@onready var stamp_mask = $StampMask as TextureRect

var is_wrong : bool

signal on_page_changed(pageRes : PageResource)

var approvedTexture = load("res://Assets/APPROVED.png")
var deniedTexture = load("res://Assets/DENIED.png")

func set_page_resource(pageRes : PageResource) -> void:
	page_resource = pageRes
	
	titleLabel.text = pageRes.title + " ™"
	softwareLabel.text = "Descrição do Software:\n" + pageRes.software_desc
	managementLabel.text = "Como o software irá se manter:\n" + pageRes.management_desc
	
	contextAndUsageLabel.text = "Contexto de uso e implicações:\n" + pageRes.software_context_desc
	
	workplaceLabel.text = "Ambiente de trabalho: \n" + pageRes.workplace_desc
	
	if on_page_changed.has_connections():
		on_page_changed.emit(pageRes)
	
	is_wrong = pageRes.isWrong

func _on_approved_stamp_on_dropped(body: CharacterBody2D, pos: Vector2) -> void:
		var ap = Sprite2D.new()
		ap.texture = approvedTexture
		ap.z_index = 9999
		stamp_mask.add_child(ap)
		#ap.rotation = randf_range(0,2.5)
		ap.global_position = pos + Vector2(0, 90)
		
		#clear stamp texture for next page
		await get_tree().create_timer(3.0).timeout
		ap.queue_free()


func _on_denied_stamp_on_dropped(body: CharacterBody2D, pos: Vector2) -> void:
		var ap = Sprite2D.new()
		ap.texture = deniedTexture
		ap.z_index = 9999
		stamp_mask.add_child(ap)
		#ap.rotation = randf_range(0,2.5)
		ap.global_position = pos + Vector2(0, 79)
		
		#clear stamp texture for next page
		await get_tree().create_timer(3.0).timeout
		ap.queue_free()
		
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if page_resource != null:
			set_page_resource(page_resource)
		
