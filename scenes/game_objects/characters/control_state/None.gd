extends CharacterState


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	parent.process(delta)
	


func physics_process(delta):
	parent.physics_process(delta)


func get_look_position() -> Vector3:
	
	return character.global_transform.origin
	

func get_move_target() -> Vector3:
	
	return character.global_transform.origin
	
