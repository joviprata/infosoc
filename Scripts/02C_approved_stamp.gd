class_name ApprovedStamp
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var stamp_up_sound = $StampUpSound
@onready var stamp_down_sound = $StampDownSound

var dragging := false
var was_dragged := false

signal on_dropped(body: CharacterBody2D, pos: Vector2)

func _ready() -> void:
	set_physics_process(true)
	collision_shape_2d.disabled = false
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var space_state = get_world_2d().direct_space_state
			var params = PhysicsPointQueryParameters2D.new()
			params.position = event.position
			params.collide_with_areas = false
			params.collide_with_bodies = true

			var result = space_state.intersect_point(params, 10)

			if result.size() > 0 and result[0].get("collider") == self:
				dragging = true
				was_dragged = true
				collision_shape_2d.disabled = true
		elif not event.pressed and dragging:
			dragging = false
			was_dragged = false

			# Temporarily disable movement
			set_physics_process(false)
			collision_shape_2d.disabled = false

			# Play stamp down sound and move down by 5 pixels
			stamp_down_sound.play()
			position.y += 5

			# Wait 0.5 seconds
			await get_tree().create_timer(0.5).timeout

			# Move up by 5 pixels and re-enable movement
			position.y -= 5
			stamp_up_sound.play()
			set_physics_process(true)

			if on_dropped.has_connections():
				on_dropped.emit(self, event.position)



func _physics_process(delta: float) -> void:
	if dragging:
		var mouse_pos = get_global_mouse_position()
		var top_center_offset = Vector2(0, -sprite_2d.texture.get_size().y / 2 + 10)
		global_position = mouse_pos - top_center_offset
