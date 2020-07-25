extends CharacterGoapAction


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func execute(actor) -> bool:
	
	var position = actor.global_transform.origin + Vector3(randf(), 0.0, randf() ).normalized() * 8
	
	move_to_position( position )
	
	if not yield(goap_planner.goap_state_machine, "on_move_reached"):
		print("Cannot end TakeBox action")
		emit_signal("on_action_end", false)
		return
	
	return true
	
