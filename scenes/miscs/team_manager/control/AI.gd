extends TeamManagerState



var ai_plan_executed := 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func enter(msg : Dictionary = {}):
	var characters = get_tree().get_nodes_in_group("character")
	for character in characters:
		if character.team == team_manager.team:
			team_manager.team_members.append(character)
			character.detection.connect("ennemy_detected", self, "_on_ennemy_detected")
			character.connect("selected", self, "_on_character_selected")
			character.control_state.connect("transitioned", self, "_on_control_transitioned")
			
	owner.emit_signal("squad_updated")


func exit():
	for character in team_manager.team_members:
		character.detection.disconnect("ennemy_detected", self, "_on_ennemy_detected")
		character.disconnect("selected", self, "_on_character_selected")


func execute():
	
	ai_plan_executed = 0
	
	print("execute AI")
	
	# TODO : analyse best position
	
	# TODO : define action plan for all team member
	
	var message = {
		"goals": [ "see_ennemy" if parent.ennemies.empty() else "attack" ]
	}
	
	for character in team_manager.team_members:
		character.control_state.transition_to("Control/AI", message)
	
	pass


func get_best_position() -> PoolVector3Array:
	var nav = NavigationManager.get_navigation()
	var cells = nav.gridmap.get_used_cells()
	var best_position := PoolVector3Array()
	for cell in cells:
		var item = nav.gridmap.get_cell_item(cell.x, cell.y, cell.z)
		if item == 2:
			best_position.append( nav.gridmap.map_to_world(cell.x, cell.y, cell.z) )
	return best_position


func _on_character_selected(character):
	
	parent.character_selected = character
	


func _on_ennemy_detected(ennemy, _character):
	
	parent.ennemies.append(ennemy)
	
	pass


func _on_control_transitioned(state_path, message):
	
	print("_on_control_transitioned to ", state_path)
	
	if state_path == "Control/None":
		ai_plan_executed += 1
	
	if ai_plan_executed == team_manager.team_members.size():
		team_manager.emit_signal("turn_finished")
	
	pass

