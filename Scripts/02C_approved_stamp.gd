class_name ApprovedStamp
extends CharacterBody2D

signal stamp_drag_started
signal on_dropped(body: CharacterBody2D, pos: Vector2)
signal on_stamped(is_approved : bool)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var stamp_up_sound = $StampUpSound
@onready var stamp_down_sound = $StampDownSound
@onready var stamp_dragstart_sound = $StampDragstartSound
@onready var stamp_drop_sound = $StampDropSound

@onready var denied_stamp = $"../DeniedStamp"
@onready var game_scene = $".."

var dragging := false
var was_dragged := false
var can_interact := true

# VARIABLE FOR STAMP PAGE BOUNDARIES:
var initial_position: Vector2

func _ready() -> void:
	set_physics_process(true)
	collision_shape_2d.disabled = false
	initial_position = position

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
				stamp_dragstart_sound.play()
				stamp_drag_started.emit()
				dragging = true
				was_dragged = true
				collision_shape_2d.disabled = true

		elif not event.pressed and dragging:
			_handle_drop(event.position)

func _handle_drop(drop_pos: Vector2) -> void:
	dragging = false
	was_dragged = false
	collision_shape_2d.disabled = false
	set_physics_process(false)
	can_interact = false

	var stamp_area = Rect2(Vector2(579, -30), Vector2(296, 360))

	if stamp_area.has_point(drop_pos) and game_scene.can_stamp and denied_stamp.can_interact:
		# Stamping behavior
		stamp_down_sound.play()
		position.y += 5
		await get_tree().create_timer(0.5).timeout
		position.y -= 5
		stamp_up_sound.play()

		if on_dropped.has_connections():
			on_dropped.emit(self, drop_pos)

		var tween := create_tween()
		tween.tween_property(self, "position", initial_position, 0.8)\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await tween.finished

		can_interact = true
		set_physics_process(true)

		if on_stamped.has_connections():
			on_stamped.emit(true)
	else:
		stamp_drop_sound.play()
		await _return_to_initial()

func _physics_process(delta: float) -> void:
	if dragging:
		var mouse_pos = get_global_mouse_position()
		var top_center_offset = Vector2(0, -sprite_2d.texture.get_size().y / 2 + 10)
		global_position = mouse_pos - top_center_offset

func is_dragging() -> bool:
	return dragging

func release_drag() -> void:
	if dragging:
		dragging = false
		was_dragged = false
		collision_shape_2d.disabled = false
		set_physics_process(false)
		can_interact = false
		# Start tween to initial position
		await _return_to_initial()

func _return_to_initial() -> void:
	var tween := create_tween()
	tween.tween_property(self, "position", initial_position, 0.5)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	can_interact = true
	set_physics_process(true)
