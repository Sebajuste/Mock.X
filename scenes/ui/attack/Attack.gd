extends Control


onready var damage_label = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/Damage
onready var hit_label = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/Hit
onready var critical_label = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/Critical


var shooter : Character setget set_shooter
var target : Character setget set_target

var min_damage := 3
var max_damage := 5

#var hit_chance := 0.0
var critical_chance := 20.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_info():
	
	if not shooter or not target:
		hit_label.text = "---"
		return
	
	min_damage = shooter.combat_stats.min_damage
	max_damage = shooter.combat_stats.max_damage
	critical_chance = shooter.combat_stats.critical_chance
	
	var space_state : PhysicsDirectSpaceState = shooter.get_world().direct_space_state
	
	var result := space_state.intersect_ray(
		shooter.global_transform.origin,
		target.global_transform.origin,
		[shooter]
	)
	
	if result.has("collider") and result.collider != target:
		hit_label.text = "0 %"
	else:
		var distance_squared := shooter.global_transform.origin.distance_squared_to(target.global_transform.origin)
		var hit_chance = max(0, 100 - distance_squared)
		hit_label.text = ("%d" % hit_chance ) + " %"
		
	


func set_shooter(value: Character):
	shooter = value
	
	damage_label.text = "%d-%d" % [min_damage, max_damage]
	critical_label.text = ("%2.1f" % critical_chance) + " %"
	
	update_info()


func set_target(value: Character):
	
	target = value
	update_info()



func _on_FireButton_pressed():
	
	
	
	
	shooter.attack(target)
	
	
	
	
	
	pass # Replace with function body.
