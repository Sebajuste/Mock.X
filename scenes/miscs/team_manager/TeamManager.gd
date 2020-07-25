class_name TeamManager
extends Node

signal squad_updated()
signal selected(character)
signal unselected(character)
signal turn_finished

export var team := "Team Name"
export(String, "None", "Player", "AI") var control := "None" setget set_control

onready var control_state := $ControlSM

var team_members := []


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func select(character : Character):
	
	$ControlSM/Control.character_selected = character
	


func get_selected() -> Character:
	
	return $ControlSM/Control.character_selected
	


func unselect():
	
	$ControlSM/Control.character_selected = null
	


func get_ennemies() -> Array:
	
	return []
	


func set_control(value):
	
	control = value
	$ControlSM.transition_to("Control/%s" % value)
	

