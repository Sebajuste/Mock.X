extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity := Vector3.ZERO


var path := PoolVector3Array()

var move_position = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	
	
	if move_position == null and not path.empty():
		move_position = path[0]
		path.remove(0)
	
	var force := Vector3.ZERO
	
	if move_position:
		force = move_position - global_transform.origin
		force = force.normalized()
		
		if global_transform.origin.distance_to(move_position) <= 0.3:
			move_position = null
	
	velocity = force
	
	velocity = velocity.normalized() * 3
	
	velocity += Vector3.DOWN
	
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	


func move_path(value : PoolVector3Array):
	
	path = value
	
	pass
