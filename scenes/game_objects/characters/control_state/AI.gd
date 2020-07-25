extends CharacterState


signal plan_executed


onready var goap_state_machine = $GoapSM

onready var goap = $GoapSM/Goap

onready var goap_planner = $GoapPlanner

var boid_config : BoidConfig
var enable_boid := false


var enable_target := false
var target_ref := weakref(null)



# Called when the node enters the scene tree for the first time.
func _ready():
	
	$GoapSM/Goap.control = parent
	goap_state_machine.enabled = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func process(delta):
#	pass


#func physics_process(delta):
#	pass


func enter(_message : Dictionary = {}):
	
	print("AI !", _message)
	
	goap_state_machine.enabled = true
	goap_state_machine.transition_to("Goap/Idle", _message)


func exit():
	
	goap_state_machine.enabled = false
	goap_state_machine.transition_to("Goap/Disable")
