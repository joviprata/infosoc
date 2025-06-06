#exatamente a mesma coisa que 02C_approved_stamp.gd, só muda o class_name


class_name DeniedStamp
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var stamp_up_sound = $StampUpSound
@onready var stamp_down_sound = $StampDownSound

var dragging := false
var was_dragged := false
var can_interact := true

signal on_dropped(body: CharacterBody2D, pos: Vector2)
signal on_stamped(is_approved : bool)

func _ready() -> void:
	set_physics_process(true)
	collision_shape_2d.disabled = false

func _input(event: InputEvent) -> void:
	if not can_interact:
		return

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

			# Temporarily disable interaction and physics
			can_interact = false
			set_physics_process(false)
			collision_shape_2d.disabled = false

			# Play stamp down sound and move down by 5 pixels
			stamp_down_sound.play()
			position.y += 5

			await get_tree().create_timer(0.5).timeout

			# Move up and play stamp up sound
			position.y -= 5
			stamp_up_sound.play()

			if on_dropped.has_connections():
				on_dropped.emit(self, event.position)

			# Animate back to position (601, 455)
			var target_position = Vector2(839, 466)
			var tween := create_tween()
			tween.tween_property(self, "position", target_position, 0.8)\
				.set_trans(Tween.TRANS_QUAD)\
				.set_ease(Tween.EASE_OUT)

			# Wait for tween to finish before enabling interaction
			await tween.finished
			can_interact = true
			set_physics_process(true)
			
			if on_stamped.has_connections():
				on_stamped.emit(false)
			
			
			

func _physics_process(delta: float) -> void:
	if dragging:
		var mouse_pos = get_global_mouse_position()
		var top_center_offset = Vector2(0, -sprite_2d.texture.get_size().y / 2 + 10)
		global_position = mouse_pos - top_center_offset
