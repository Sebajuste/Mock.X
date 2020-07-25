extends TeamManagerState


var character_selected : Character setget set_character_selected

var ennemies := []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func set_character_selected(value):
	if character_selected == value:
		return
	
	if character_selected:
		owner.emit_signal("unselected", character_selected)
	
	character_selected = value
	
	if character_selected:
		owner.emit_signal("selected", character_selected)
