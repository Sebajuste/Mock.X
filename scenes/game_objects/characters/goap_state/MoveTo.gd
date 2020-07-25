extends CharacterState



var move_path : PoolVector3Array

var move_reached := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func enter(message : Dictionary = {}):
	
	print("Need move")
	
	#parent.control.connect("destination_reached", self, "_on_destination_reached")
	
	parent.control.path = NavigationManager.get_simple_path(character.global_transform.origin, message.target_position )
	
	if not yield(parent.control, "destination_reached"):
		print("Cannot end TakeHeal action")
		#emit_signal("on_action_end", false)
		state_machine.transition_to("Goap/Idle")
		return
	state_machine.transition_to("Goap/Idle")
	#emit_signal("on_action_end", true)
	
	pass


func exit():
	#parent.control.disconnect("destination_reached", self, "_on_destination_reached")
	var result = move_reached
	move_reached = false
	state_machine.emit_signal("on_move_reached", result)
	pass


func _on_destination_reached():
	
	#state_machine.transition_to("Goap/Idle")
	
	pass
