extends CharacterState


var target_position : Vector3
var target_distance : float = 0.0
var need_move := false
var move_reached := false

var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func physics_process(_delta):
	
	if need_move:
		var path := NavigationManager.get_simple_path(character.global_transform.origin, target_position )
		
		parent.control.set_path(path)
		need_move = false
		if not yield(parent.control, "destination_reached"):
			print("Cannot end Move action")
			#emit_signal("on_action_end", false)
			state_machine.transition_to("Goap/Idle")
			return
		
		print("move stop immediately")
		state_machine.transition_to("Goap/Idle")
	else:
		
		var distance = character.global_transform.origin.distance_to(target_position)
		if distance <= target_distance and (target == null or character.can_see(target) ):
			print("move stop - close ok")
			parent.control.set_path(null)
			pass
	
	
	pass


func enter(message : Dictionary = {}):
	
	print("Need move")
	
	#parent.control.connect("destination_reached", self, "_on_destination_reached")
	if message.has("target"):
		target = message.target
	target_position = message.target_position
	target_distance = message.target_distance
	need_move = true
	#parent.control.path = NavigationManager.get_simple_path(character.global_transform.origin, message.target_position )
	
	
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
