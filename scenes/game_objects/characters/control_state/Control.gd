extends CharacterState


signal moved
signal destination_reached(result)


var path := PoolVector3Array() setget set_path
var moving := false
var move_canceled := false

var next_move_position : Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func physics_process(delta):
	
	if path.size() > 1:
		
		if not moving:
			next_move_position = next_position()
			moving = true
			return
	
	if moving and character.global_transform.origin.distance_squared_to(next_move_position) < 0.1:
		
		moving = false
		emit_signal("moved")
		character.global_transform.origin = next_move_position
		
		if path.size() <= 1:
			emit_signal("destination_reached", not move_canceled)
		else:
			next_move_position = next_position()
			moving = true


func get_move_target() -> Vector3:
	
	return next_move_position if moving else character.global_transform.origin
	


func get_look_position() -> Vector3:
	
	return get_move_target()
	


func next_position() -> Vector3:
	var position = path[0]
	position.y = 0
	path.remove(0)
	return position


func set_path(value):
	
	if value == null:
		path = PoolVector3Array()
		if moving:
			moving = false
			move_canceled = true
			emit_signal("destination_reached", false)
	else:
		path = value
		path.remove(0)
