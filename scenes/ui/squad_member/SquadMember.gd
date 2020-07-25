extends Control


onready var name_label := $MarginContainer/Panel/MarginContainer/VBoxContainer/Name
onready var life_label := $MarginContainer/Panel/MarginContainer/VBoxContainer/Life/Value
onready var action_points_label := $MarginContainer/Panel/MarginContainer/VBoxContainer/ActionPoints/Value

var character : Character setget set_character

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_character(value : Character):
	
	if value == null and character != null:
		value.disconnect("action_point_changed", self, "_on_action_point_changed")
		pass
	
	if value != null:
		value.connect("action_point_changed", self, "_on_action_point_changed")
		_on_action_point_changed(value.action_points, value.action_points, value.max_points)
		name_label.text = value.name
		pass
	
	character = value
	
	
	
	pass


func _on_action_point_changed(_old, current, max_points):
	
	action_points_label.text = "%d / %d" % [current, max_points]
	
	pass
