extends Node


var current_scene : Node


onready var load_screen = $Loading


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Loading.connect("scene_loading", self, "_on_scene_loading")
	Loading.connect("global_load_progress", self, "_on_global_load_progress")
	Loading.connect("global_loaded", self, "_on_global_loaded")
	
	Loading.connect("global_loading", self, "_on_global_loading")
	
	#Loading.connect("scene_loaded", self, "_on_scene_loaded")
	
	Loading.load_scene("res://scenes/menus/level_selector/LevelSelector.tscn", {"switch": true})
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

"""
func remove_current_scene():
	if current_scene:
		current_scene.queue_free()
		current_scene = null
"""

func clear_scenes():
	
	for child in $Content.get_children():
		child.queue_free()
	

"""
func _on_scene_loading(scene_path, context):
	print("Loading scene [%s] " % scene_path, context)
	if not context.has("switch") or context.switch == true:
		#$Loading.visible = true
		remove_current_scene()
"""

func _on_global_load_progress(current_stage, stage_count):
	print("Loading scene [%d / %d]" % [current_stage, stage_count])
	load_screen.set_progress(0, stage_count, current_stage)

"""
func _on_scene_loaded(scene: Node, context: Dictionary):
	print("[%s] Scene loaded " % scene.name, context)
	#$Loading.visible = false
	if context.has("switch") and context.switch == true:
		remove_current_scene()
		current_scene = scene
		print("remove old scene")
	$Content.add_child(scene)
	
	if scene.has_method("init"):
		scene.init(context)
"""

func _on_global_loading(loading):
	
	if loading:
		clear_scenes()
		load_screen.visible = true
	
	print("_on_global_loading : ", loading)
	#if not loading:
	#	yield(self, "ready")
	#	load_screen.visible = false
	


func _on_global_loaded(instance_list : Array):
	
	print("_on_global_loaded ", instance_list)
	
	clear_scenes()
	
	var root = null
	
	for instance in instance_list:
		var scene = instance.scene
		if instance.context.has("root") and instance.context.root or root == null:
			root = scene
		
		if instance.context.has("child") and instance.context.child:
			root.add_child(scene)
		#else:
		#	$Content.add_child(scene)
	
	$Content.add_child(root)
	current_scene = root
	
	print("Scenes added")
	
	for instance in instance_list:
		var scene = instance.scene
		if scene.has_method("init"):
			scene.init(instance.context)
	
	load_screen.visible = false
	
	pass

