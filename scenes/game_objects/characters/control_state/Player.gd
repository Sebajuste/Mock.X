extends CharacterState


var mode := "Move"


var look_position := Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	parent.process(delta)


func physics_process(delta):
	parent.physics_process(delta)


func unhandled_input(event: InputEvent):
	
	if event is InputEventMouseButton:
		
		#
		# Move
		#
		if mode == "Move" and event.pressed and Input.is_action_just_pressed("select"):
			var look_position = _get_mouse_look_position()
			
			var start_position = NavigationManager.get_closest_point( character.global_transform.origin )
			var end_position = NavigationManager.get_closest_point(look_position)
			
			if end_position.distance_to(character.global_transform.origin) > 1.0:
				var path = NavigationManager.get_simple_path(start_position, end_position)
				#path.remove(0) # remove the current position
				parent.path = path
			
	
	pass


func enter(_message : Dictionary = {}):
	
	mode = "Move"
	


func exit():
	
	pass
	


func get_look_position() -> Vector3:
	
	return Vector3.ZERO


func get_move_target() -> Vector3:
	
	return Vector3.ZERO
	

"""
func _get_mouse_look_position() -> Vector3:
	var mouse_pos := get_viewport().get_mouse_position()
	
	var camera := get_tree().get_root().get_camera()
	
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * 1000
	
	var space_state := player.get_world().direct_space_state
	var result := space_state.intersect_ray(from, to)
	
	if result:
		var dir : Vector3 = (result.position - player.global_transform.origin)
		dir.y = 0
		dir = dir.normalized()
		
		$Target.global_transform.origin = result.position
		
		return result.position
	else:
		return Vector3.ZERO
	
	pass
"""

func _get_mouse_look_position() -> Vector3:
	var mouse_pos := get_viewport().get_mouse_position()
	
	var camera := get_tree().get_root().get_camera()
	
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * 1000
	
	var space_state := character.get_world().direct_space_state
	var result := space_state.intersect_ray(from, to)
	
	if result:
		return result.position
	return Vector3.ZERO



func _get_input_direction() -> Vector3:
	return Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0,
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)


func _get_look_input_direction() -> Vector3:
	return Vector3(
		Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
		0,
		Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	)
