extends CharacterState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var action = null

var action_running := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func physics_process(delta):
	
	if action_running:
		false
	
	if action:
		print("[Animation] START action : ", action.name)
		action_running = true
		var result = action.execute(character)
		
		if typeof(result) == TYPE_BOOL and result:
			pass
		elif (typeof(result) == TYPE_BOOL and not result) or not result or not yield(action, "on_action_end"):
			state_machine.transition_to("Goap/Idle")
			action_running = false
			print("[Animation] END action : ", result)
			return
		
		print("[Animation] END action")
		
		action_running = false
		state_machine.transition_to("Goap/Idle")
	else:
		state_machine.transition_to("Goap/Idle")



func enter(message : Dictionary = {}):
	
	action = message.action
	print("Action start ", message)


func exit():
	
	print("Action end")
	pass
