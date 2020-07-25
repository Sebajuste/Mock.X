extends Button

signal selected(character)

onready var squad_member_name := $MarginContainer/VBoxContainer/Name
onready var action_points := $MarginContainer/VBoxContainer/ActionPoint/Value

var character : Character setget set_character


# Called when the node enters the scene tree for the first time.
func _ready():
	
	squad_member_name.text = character.name
	
	_on_action_point_changed(character.action_points, character.action_points, character.max_points)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_character(value : Character):
	
	if character != null:
		character.disconnect("action_point_changed", self, "_on_action_point_changed")
	
	character = value
	
	if value != null and squad_member_name:
		squad_member_name.text = value.name
	
	character.connect("action_point_changed", self, "_on_action_point_changed")
	


func _on_SquadItem_gui_input(event):
	
	print(event)
	
	pass # Replace with function body.


func _on_action_point_changed(_old, current, max_value):
	
	action_points.text = "%d/%d" % [current, max_value]
	


func _on_SquadItem_pressed():
	
	emit_signal("selected", character)
	
