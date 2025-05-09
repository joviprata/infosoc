class_name DraggableObject extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		position = event.position

func _process(delta: float) -> void:
	print(get_viewport().get_mouse_position())
