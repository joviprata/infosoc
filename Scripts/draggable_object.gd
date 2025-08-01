class_name DraggableObject
extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var dragging := false
signal on_dropped(body: RigidBody2D, pos: Vector2)

func _ready() -> void:
	freeze = true
	gravity_scale = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var space_state = get_world_2d().direct_space_state
			var params = PhysicsPointQueryParameters2D.new()
			params.position = event.position
			params.collide_with_areas = false
			params.collide_with_bodies = true
			params.collision_mask = collision_layer  # or set manually like: `params.collision_mask = 1`

			var result = space_state.intersect_point(params, 1)

			# Only drag if this is the topmost object
			if result.size() > 0 and result[0].get("collider") == self:
				dragging = true
				freeze = true

		elif not event.pressed and dragging:
			dragging = false
			freeze = false
			if on_dropped.has_connections():
				on_dropped.emit(self, event.position)




func _physics_process(delta: float) -> void:
	if dragging:
		var mouse_pos = get_global_mouse_position()
		
		# Get top center of sprite, 10 pixels down
		var top_center_offset = Vector2(0, -sprite_2d.texture.get_size().y / 2 + 10)
		
		# Position object so that top-center sits under the mouse
		global_position = mouse_pos - top_center_offset
