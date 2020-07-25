extends CharacterGoapAction


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func is_reachable(context: Dictionary) -> bool:
	return context.action_points >= 4


func execute(actor) -> bool:
	
	var ennemy = actor.get_nearest_ennemy()
	
	if ennemy:
		actor.attack(ennemy)
		return true
	
	return false
