class_name CharacterGoapAction
extends GoapAction


onready var character : Character = owner


func move_to_position(position : Vector3, min_distance := 0):
	var nav = NavigationManager.get_navigation()
	goap_planner.goap_state_machine.transition_to("Goap/MoveTo", {
		"target_position": nav.get_closest_point( position ),
		"target_distance": min_distance
	})


func move_to_target(target : Spatial,  min_distance := 0):
	var nav = NavigationManager.get_navigation()
	goap_planner.goap_state_machine.transition_to("Goap/MoveTo", {
		"target": target,
		"target_position": nav.get_closest_point( target.global_transform.origin ),
		"target_distance": min_distance
	})
