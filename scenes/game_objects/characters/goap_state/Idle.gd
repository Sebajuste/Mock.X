extends CharacterState



var action_plan := []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func physics_process(delta):
	
	if not action_plan.empty():
		var action = action_plan.pop_front()
		state_machine.transition_to("Goap/Action", {
			"action": action
		})
	else:
		print("End actions")
		
		var ai = character.control_state.state
		ai.emit_signal("plan_executed")
		
		state_machine.transition_to("Goap/Disable")



func enter(message : Dictionary = {}):
	
	if message.has("goals"):
		
		var range_ennemy = false
		var nearest_ennemy = character.get_nearest_ennemy()
		if nearest_ennemy:
			var distance = nearest_ennemy.global_transform.origin.distance_to(character.global_transform.origin)
			if distance < 8 and character.can_see(nearest_ennemy):
				range_ennemy = true
		
		var ennemy_detected : bool = not character.detection.ennemies.empty()
		
		state_machine.goap_planner.world_state["see_ennemy"] = ennemy_detected
		state_machine.goap_planner.world_state["range_ennemy"] = range_ennemy
		state_machine.goap_planner.world_state["cover"] = false
		
		for name in message.goals:
			state_machine.goap_planner.goal_state[name] = true
		
		action_plan = state_machine.goap_planner.create_plan({
			"nearest_ennemy": nearest_ennemy,
			"action_points": character.action_points
		})
		_print_action_plan(action_plan)


func exit():
	
	pass


func _print_action_plan(action_plan : Array):
	var message = "Action plan "
	for action in action_plan:
		message += "> %s" % action.name
	print(message)
