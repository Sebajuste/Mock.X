extends Spatial



export(NodePath) var target_path
export(float) var area_percent = 0.025
export(int) var acc = 10
export(int) var dec = 25
export(int) var MAX_SPEED = 100
export(int) var ang_acc = 3
export(int) var ang_dec = 8
export(int) var MAX_ANG_SPEED = 50
export(float) var MOUSE_SENSITIVITY = 0.001


onready var target : Spatial = get_node(target_path)


var crsr := Vector2.ZERO
var speed := 0.0
var angl = -1
var angr = 1


var last_dir := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if target:
		#global_transform.origin = target.global_transform.origin
		
		global_transform.origin = global_transform.origin.linear_interpolate( target.global_transform.origin, 4 * delta )
		
	
	
	#rotate_y( deg2rad(delta) )
	var pos := get_viewport().size
	
	
	
	if (crsr.x < int(pos.x*area_percent)) or Input.is_action_pressed("ui_left"):
		last_dir = move_dir(Vector3.LEFT, delta)
	elif (crsr.x > (pos.x-(pos.x*area_percent))) or Input.is_action_pressed("ui_right"):
		last_dir = move_dir(Vector3.RIGHT, delta)
	elif (crsr.y < int(pos.y*area_percent)) or Input.is_action_pressed("ui_up"):
		last_dir = move_dir(Vector3.FORWARD, delta)
	elif (crsr.y > (pos.y-(pos.y*area_percent))) or Input.is_action_pressed("ui_down"):
		last_dir = move_dir(Vector3.BACK, delta)
	elif target == null:
		speed -= dec * delta
		speed = clamp(speed, 0, MAX_SPEED)
		translate(last_dir * delta * speed)
	
	if Input.is_key_pressed(KEY_E):
		angr += ang_acc * delta
		angr = clamp(angr, 0, MAX_ANG_SPEED)
		rotate_y(angr*delta)
		
	elif Input.is_key_pressed(KEY_Q):
		angl += ang_acc * delta
		angl = clamp(angl, 0, MAX_ANG_SPEED)
		rotate_y(-angl * delta)
		
	else:
		angr -= ang_dec * delta
		angr = clamp(angr, 0, MAX_ANG_SPEED)
		rotate_y(angr * delta)
		angl -= ang_dec * delta
		angl = clamp(angl, 0, MAX_ANG_SPEED)
		rotate_y(-angl * delta)
	


func _input(event):
	if event is InputEventMouseMotion: 
		crsr = event.position
	
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		self.rotate_y(event.relative.x * MOUSE_SENSITIVITY)


func move_dir(dir : Vector3, delta : float) -> Vector3:
	speed += acc * delta
	speed = clamp(speed, 0, MAX_SPEED)
	translate(dir * delta * speed)
	target = null
	return dir
