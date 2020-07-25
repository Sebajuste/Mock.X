class_name CharacterState
extends State



var character : Character


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(self.owner, "ready")
	character = self.owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
