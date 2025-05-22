class_name PageObject extends Node2D

@export var page_resource : PageResource

@onready var rich_text_label: RichTextLabel = $Description
@onready var area_2d: Area2D = $Area2D

signal on_page_changed(pageRes : PageResource)

var approvedTexture = load("res://Assets/APPROVED.png")
var deniedTexture = load("res://Assets/DENIED.png")

func set_page_resource(pageRes : PageResource) -> void:
	page_resource = pageRes
	rich_text_label.text = pageRes.textDescription
	
	if on_page_changed.has_connections():
		on_page_changed.emit(pageRes)


func _on_stamp_aproval_dropped(body: RigidBody2D, pos: Vector2) -> void:
	
		var ap = Sprite2D.new()
		ap.texture = approvedTexture
		add_child(ap)
		ap.rotation = randf_range(0,2.5)
		ap.global_position = pos
