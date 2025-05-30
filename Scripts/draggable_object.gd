class_name DraggableObject extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var dragging := false
var is_inside_dropable := false
var body_ref
var initialPos : Vector2

signal on_dropped(body : Node, pos : Vector2)

func _ready() -> void:
	# Deixa o corpo inicialmente parado
	initialPos = global_position

func _physics_process(delta: float) -> void:
	if dragging:
		if Input.is_action_pressed("touch_contact"):
		# Segue o mouse enquanto estiver arrastando
			var mouse_pos = get_global_mouse_position()
			global_position = mouse_pos
		elif Input.is_action_just_released("touch_contact"):
			var moveTween = get_tree().create_tween()
			if is_inside_dropable:
				moveTween.tween_property(self,"position",body_ref.position,0.2).set_ease(Tween.EASE_IN_OUT)
			else:
				moveTween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_IN_OUT)
				

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('droppable'):
		is_inside_dropable = true
		body_ref = body
		on_dropped.emit(self, body_ref.position)
		body.modulate = Color(Color.REBECCA_PURPLE,1)
		print("Entered Droppable body")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('droppable'):
		is_inside_dropable = false
		body.modulate = Color(Color.WHITE,1)
		print("Exited Droppable body")


func _on_area_2d_mouse_entered() -> void:
	dragging = true
	scale = Vector2(1.1,1.1)


func _on_area_2d_mouse_exited() -> void:
	dragging = false
	scale = Vector2(1,1)

func reset_position() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position",initialPos,.2)
	
