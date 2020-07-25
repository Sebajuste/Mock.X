extends CharacterState


signal moved
signal destination_reached(result)


var path := PoolVector3Array() setget set_path
var moving := false
var move_canceled := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func physics_process(delta):
	if not path.empty():
		var next_position = path[0]
		if next_position.distance_to(character.global_transform.origin) <= 0.5:
			moving = true
			emit_signal("moved")
			path.remove(0)
	elif moving:
		moving = false
		emit_signal("destination_reached", not move_canceled)


func get_move_target() -> Vector3:
	if not path.empty():
		return path[0]
	return character.global_transform.origin


func get_look_position() -> Vector3:
	
	return get_move_target()
	


func set_path(value):
	path = value
	if value == null:
		move_canceled = true

