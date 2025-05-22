class_name DraggableObject
extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var dragging := false

signal on_dropped(body : RigidBody2D, pos : Vector2)

func _ready() -> void:
	# Deixa o corpo inicialmente parado
	freeze = true
	gravity_scale = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# Verifica se clicou sobre este objeto
			if collision_shape_2d.shape and collision_shape_2d.shape.get_rect().has_point(to_local(event.position)):
				dragging = true
				freeze = true  # Pausa a física
		elif not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# Solta o objeto
			dragging = false
			freeze = false
			if on_dropped.has_connections():
				on_dropped.emit(self,event.position)
	
	if Input.is_action_pressed("touch_contact"):
		print("Interacting")

func _physics_process(delta: float) -> void:
	if dragging:
		# Segue o mouse enquanto arrastando
		var mouse_pos = get_global_mouse_position()
		global_position = mouse_pos
