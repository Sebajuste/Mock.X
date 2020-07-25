extends Control

const LEVEL_BUTTON = preload("res://scenes/menus/level_selector/LevelButton.tscn")


const PATH = "res://scenes/levels/"


onready var level_list := $VBoxContainer/ScrollContainer/LevelList


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var files = []
	
	var dir := Directory.new()
	dir.open(PATH)
	dir.list_dir_begin()
	
	while true:
		var file := dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			
			analyse_level_dir(file)
			
			files.append(file)
	
	dir.list_dir_end()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func analyse_level_dir(dir_name):
	
	var dir := Directory.new()
	dir.open(PATH + dir_name)
	dir.list_dir_begin()
	
	while true:
		var file := dir.get_next()
		if file == "":
			break
		elif file.ends_with(".tscn"):
			
			var btn = LEVEL_BUTTON.instance()
			btn.level_file_name = PATH + dir_name + "/" + file
			btn.text = file
			level_list.add_child(btn)
	
	dir.list_dir_begin()

