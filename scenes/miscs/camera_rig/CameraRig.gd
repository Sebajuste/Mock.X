extends Spatial



export(NodePath) var target_path
export var offset : Vector3 = Vector3(0, 8.7, 10)

onready var target_ref := weakref(get_node(target_path))

var look_target_ref := weakref(null)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_as_toplevel(true)
	

var angle = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	angle += delta * 10
	 
	var target = target_ref.get_ref()
	if target:
		#var target_pos = target.global_transform.origin + offset
		#target_pos = target_pos.rotated(Vector3.UP, deg2rad(90) )
		
		var final_transform = Transform(Basis(), target.global_transform.origin + offset)
		final_transform = final_transform.rotated(Vector3.UP, deg2rad(angle) )
		final_transform = final_transform.looking_at(target.global_transform.origin, Vector3.UP)
		self.global_transform = self.global_transform.interpolate_with(final_transform, delta * 4)
	
	
	var look_target = look_target_ref.get_ref()
	if look_target:
		self.global_transform.looking_at(look_target.global_transform.origin, Vector3.UP)
		pass


func set_follow_target(target : Spatial):
	
	target_ref = weakref(target)
	


func set_look_target(target : Spatial):
	
	look_target_ref = weakref(target)
	
