extends Button


var level_file_name := ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LevelButton_pressed():
	
	Loading.load_scene("res://scenes/games/solo/Solo.tscn", {
		"switch": true,
		"level": level_file_name,
		"root": true
	})
	
	Loading.load_scene(level_file_name, {
		"child": true
	})

	pass # Replace with function body.
