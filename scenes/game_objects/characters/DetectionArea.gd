extends Area

signal ennemy_detected(ennemy, character)
signal ennemy_disapear(ennemy)


var ennemies := []

#var ennemies_detected := []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DetectionArea_body_entered(body):
	
	if body.team != owner.team:
		ennemies.append(body)
		# TODO : only if not detected by team
		# owner.stop_move()
		emit_signal("ennemy_detected", body, owner)
	


func _on_DetectionArea_body_exited(body):
	var index = ennemies.find(body)
	if index != -1:
		ennemies.remove(index)
		emit_signal("ennemy_disapear", body)
