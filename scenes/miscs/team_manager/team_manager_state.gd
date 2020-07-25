class_name TeamManagerState
extends State


var team_manager : TeamManager


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(self.owner, "ready")
	team_manager = self.owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
