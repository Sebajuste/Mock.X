extends CharacterGoapAction



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func execute(actor) -> bool:
	
	print("RangeEnnemy execute")
	
	var ennemy = actor.get_nearest_ennemy()
	
	var ai = actor.control_state.state
	
	# TODO : move random direction
	
	#var position = actor.global_transform.origin + Vector3(randf() * 8, 0.0, randf() * 8).normalized()
	
	move_to_position( ennemy.global_transform.origin, 8 )
	
	if not yield(goap_planner.goap_state_machine, "on_move_reached"):
		print("Cannot end TakeBox action")
		emit_signal("on_action_end", false)
		return
	
	return false
	


func get_nearest_ennemy() -> Character:
	
	var min_distance = null
	var nearest_ennemy = null
	
	for ennemy in character.detection.ennemies:
		var distance = ennemy.global_transform.origin.distance_to(character.global_transform.origin)
		if min_distance == null or distance < min_distance:
			min_distance = distance
			nearest_ennemy = ennemy
	
	return nearest_ennemy
