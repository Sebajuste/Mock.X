extends TeamManagerState





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	
	var navigation = NavigationManager.get_navigation()
	
	if parent.character_selected and parent.character_selected.control_state.state_name == "Player" and parent.character_selected.control_state.state.mode == "Move":
		var look_position = get_mouse_look_position()
		
		var start_position = navigation.get_closest_point( parent.character_selected.global_transform.origin )
		var end_position = navigation.get_closest_point(look_position)
		
		var path = navigation.get_simple_path(start_position, end_position)
		
		$ImmediateGeometry.clear()
		$ImmediateGeometry.begin(Mesh.PRIMITIVE_LINE_STRIP)
		
		var action_points = parent.character_selected.action_points
		
		for pos in path:
			if action_points == 0:
				break
			pos.y = 0.1
			$ImmediateGeometry.add_vertex(pos)
			action_points -= 1
		
		$ImmediateGeometry.end()


func unhandled_input(event):
	
	if Input.is_action_just_pressed("unselect") and parent.character_selected:
		parent.character_selected.control = "None"
		parent.character_selected = null
		
		$ImmediateGeometry.clear()



func enter(msg : Dictionary = {}):
	
	var characters = get_tree().get_nodes_in_group("character")
	for character in characters:
		if character.team == team_manager.team:
			team_manager.team_members.append(character)
			character.detection.connect("ennemy_detected", self, "_on_ennemy_detected")
			character.connect("selected", self, "_on_character_selected")
		else:
			character.visible = false
			pass
	owner.emit_signal("squad_updated")


func exit():
	for character in team_manager.team_members:
		character.detection.disconnect("ennemy_detected", self, "_on_ennemy_detected")
		character.disconnect("selected", self, "_on_character_selected")


func clear_navigation():
	
	$ImmediateGeometry.clear()
	


func get_mouse_look_position() -> Vector3:
	var mouse_pos := get_viewport().get_mouse_position()
	
	var camera := get_tree().get_root().get_camera()
	
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * 1000
	
	var space_state : PhysicsDirectSpaceState = $ImmediateGeometry.get_world().direct_space_state
	var result := space_state.intersect_ray(from, to)
	
	if result:
		return result.position
	return Vector3.ZERO


func _on_character_selected(character):

	#if character.team == $PlayerTeamManager.team:
	if parent.character_selected:
		parent.character_selected.control = "None"
		#parent.character_selected = null
	
	parent.character_selected = character
	parent.character_selected.control = "Player"
	
	#owner.emit_signal("selected", character_selected)
		#$CanvasLayer/SquadMember.set_character(character_selected)
		#$CanvasLayer/SquadMember.visible = true
		#$CanvasLayer/Actions.visible = true
		#$CanvasLayer/Combat.visible = false
	#elif character_selected and character_selected.control == "Player" and character_selected.control_state.state.mode == "Attack":
		
		#$CanvasLayer/Combat/Attack.set_target(character)
	#	pass


func _on_ennemy_detected(ennemy, character):
	ennemy.visible = true
	if parent.ennemies.find(ennemy) == -1:
		character.stop_move()
	parent.ennemies.append(ennemy)
