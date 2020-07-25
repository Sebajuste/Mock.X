extends CharacterState


const GRAVITY := 0


export var max_speed : float = 3.0
export var force := 2.5
export var slowing_radius := 1.5
export var mass := 10.0

var velocity := Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func physics_process(delta):
	
	var control = character.control_state.get_node("Control")
	
	var move_target = control.get_move_target()
	
	velocity = Steering3D.follow_with_force(
		velocity,
		character.global_transform.origin,
		move_target,
		max_speed,
		force,
		slowing_radius,
		mass
	)
	
	#if not character.is_on_floor():
	#	velocity.y = velocity.y + GRAVITY * delta
	velocity.y = 0
	
	velocity = character.move_and_slide(velocity, Vector3.UP)
	
	character.global_transform.origin.y = 0
	
	#
	# Orientation
	#
	var look_pos : Vector3 = control.get_look_position()
	look_pos.y = character.global_transform.origin.y
	if ( look_pos - character.global_transform.origin ).length_squared() > 0.1:
		var rotation : Transform = character.global_transform.looking_at(look_pos, Vector3.UP)
		character.global_transform.basis = rotation.basis
	
