tool
class_name Character
extends KinematicBody


signal selected(player)
signal action_point_changed(old, current, max_points)
signal on_death(character)



export var team := "Team_Name"
export var color := Color.white
export(String, "None", "Player", "AI") var control setget set_control
export var max_points := 8

onready var skin := $Skin

onready var control_state := $ControlSM
onready var detection := $DetectionArea
onready var combat_stats := $CombatStats

var action_points := max_points setget set_action_points

var dead := false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var mesh := skin.get_node("MeshInstance")
	
	mesh.set_surface_material(0, mesh.get_surface_material(0).duplicate())
	
	mesh.get_surface_material(0).set_shader_param("Color", color )
	
	#skin.get_node("MeshInstance").material_override["shader_param"].color = color
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func can_see(target : Spatial) -> bool:
	
	var space_state := get_world().direct_space_state
	
	print("shooter ", self.global_transform.origin)
	print("target ", target.global_transform.origin)
	
	var result := space_state.intersect_ray(
		self.global_transform.origin,
		target.global_transform.origin,
		[self]
	)
	
	print(result)
	
	return false


func move_to(position : Vector3):
	
	pass


func stop_move():
	
	$ControlSM/Control.path = PoolVector3Array()
	
	pass


func set_control(value):
	control = value
	if not dead:
		control_state.transition_to("Control/%s" % value)


func reset_action_points():
	
	self.action_points = max_points
	


func attack(target : Character):
	
	if action_points < 4:
		return
	
	var distance_squared := global_transform.origin.distance_squared_to(target.global_transform.origin)
	var hit_chance = max(0, 100 - distance_squared)
	
	var hit = true if hit_chance > randf() * 100 else false
	var crit_factor = 2.0 if combat_stats.critical_chance > randf() * 100 else 1.0
	var damage = rand_range(combat_stats.min_damage, combat_stats.max_damage) * crit_factor
	
	
	global_transform = global_transform.looking_at( target.global_transform.origin, Vector3.UP )
	
	# TODO : shoot animation
	
	action_points -= 4
	
	if hit:
		
		# TODO : hit animation
		
		# TODO : affect damage on health
		
		target.combat_stats.take_damage(damage)
		
		pass
	
	print("hit : ", hit)
	print("damage : ", damage)
	
	pass


func get_nearest_ennemy() -> Character:
	
	var min_distance = null
	var nearest_ennemy = null
	
	for ennemy in detection.ennemies:
		var distance = ennemy.global_transform.origin.distance_to(global_transform.origin)
		if min_distance == null or distance < min_distance:
			min_distance = distance
			nearest_ennemy = ennemy
	
	return nearest_ennemy


func set_action_points(value):
	value = max(0, value)
	if action_points != value:
		emit_signal("action_point_changed", action_points, value, max_points)
	action_points = value


func _on_SelectBox_input_event(camera, event, click_position, click_normal, shape_idx):
	
	if Input.is_action_just_pressed("select"):
		emit_signal("selected", self)
	


func _on_Control_moved():
	
	set_action_points(action_points - 1)
	
	if action_points <= 0:
		stop_move()
	
	pass # Replace with function body.


func _on_CombatStat_health_depleted():
	
	dead = true
	
	skin.play_animation("death")
	control_state.transition_to("Control/None")
	$LocomotionSM.transition_to("Locomotion/Dead")
	
	emit_signal("on_death", self)
	
