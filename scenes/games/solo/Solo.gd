extends Node


onready var turn_button := $CanvasLayer/Turn/MarginContainer/NextTurnButton


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NextTurnButton_pressed():
	
	turn_button.disabled = true
	
	var player_selected = $PlayerTeamManager.get_selected()
	if player_selected:
		player_selected.control = "None"
	
	$PlayerTeamManager.unselect()
	$EnnemyTeamManager.unselect()
	
	$CanvasLayer/Actions.visible = false
	$CanvasLayer/SquadMember.visible = false
	$CanvasLayer/Combat.visible = false
	
	
	# TODO : play AI
	
	$EnnemyTeamManager.control_state.state.execute()
	


func _on_turn_finished():
	
	get_tree().call_group("character", "reset_action_points")
	
	turn_button.disabled = false
	


func _on_AttackButton_pressed():
	var player_selected = $PlayerTeamManager.get_selected()
	if player_selected and player_selected.control == "Player":
		player_selected.control_state.state.mode = "Attack"
	$CanvasLayer/Combat.visible = true
	$CanvasLayer/Combat/Attack.set_shooter(player_selected)
	$PlayerTeamManager.control_state.state.clear_navigation()
	


func _on_MoveButton_pressed():
	var player_selected = $PlayerTeamManager.get_selected()
	if player_selected and player_selected.control == "Player":
		player_selected.control_state.state.mode = "Move"
	$CanvasLayer/Combat.visible = false
	$PlayerTeamManager.control_state.state.clear_navigation()


func _on_Squad_selected(character):
	
	$PlayerTeamManager.select(character)
	
	# TODO : camera focus on character
	


func _on_PlayerTeamManager_selected(character):
	$CanvasLayer/SquadMember.set_character(character)
	$CanvasLayer/SquadMember.visible = true
	$CanvasLayer/Actions.visible = true
	$CanvasLayer/Combat.visible = false


func _on_EnnemyTeamManager_selected(character):
	
	$CanvasLayer/Combat/Attack.set_target(character)
	
