extends Node

signal scene_loading(path, context)
signal scene_loaded(scene, context)
signal scene_load_progress(current_stage, stage_count)

signal global_loading(loading)
signal global_load_progress(current, total)
signal global_loaded(instance_list)

var current_scene = null

var loader_handler_list := Array()


var total_stage_count : int = 0


var loading := false
var _switch_scene := false


class LoaderHandler:
	var path : String
	var loader : ResourceInteractiveLoader
	var context : Dictionary
	var poll_index : int = 0
	var completed := false
	var instance : Node
	
	func _init(path: String, loader : ResourceInteractiveLoader, context := {}):
		self.path = path
		self.loader = loader
		self.context = context
		self.poll_index = 0
		self.instance = null




# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_loading():
		var loader_handler : LoaderHandler = _next_loader_handler()
		var loader : ResourceInteractiveLoader = loader_handler.loader
		var result = loader.poll()
		
		print("Poll -> ", result)
		
		if result == OK:
			loader_handler.poll_index += 1
			emit_signal("scene_load_progress", loader_handler.poll_index, loader.get_stage_count())
		
		if result == ERR_FILE_EOF:
			loader_handler.poll_index += 1
			var resource = loader.get_resource()
			loader_handler.completed = true
			print("Scene loaded")
			var scene = resource.instance()
			loader_handler.instance = scene
			emit_signal("scene_loaded", scene, loader_handler.context )
			if _switch_scene:
				current_scene = scene
				get_tree().get_root().add_child( current_scene )
				get_tree().set_current_scene( current_scene )
		
		if result == ERR_FILE_CORRUPT:
			push_error("Error Loading file %s" % loader_handler.path )
			loader_handler.completed = true
		
		emit_signal("global_load_progress", get_total_stage_poll(), get_total_stage_count())
		
		if not is_loading():
			var instance_list := Array()
			for handler in loader_handler_list:
				if handler.instance:
					instance_list.append({
						"scene": handler.instance,
						"context": handler.context
					})
			
			clear()
			loading = false
			
			emit_signal("global_loaded", instance_list)
			emit_signal("global_loading", loading)
		
		
	elif loading:
		push_error("Loading but no loader !")


func get_total_stage_count() -> int:
	var total := 0
	for loader_handler in loader_handler_list:
		total += loader_handler.loader.get_stage_count()
	return total


func get_total_stage_poll() -> int:
	var total := 0
	for loader_handler in loader_handler_list:
		total += loader_handler.poll_index
	return total


func count_loading_scene() -> int:
	var total := 0
	for loader_handler in loader_handler_list:
		if not loader_handler.completed:
			total += 1
	return total


func is_loading() -> bool:
	return count_loading_scene() > 0


func change_scene(path: String, context: Dictionary = {}):
	if not loading:
		loading = true
		emit_signal("global_loading", loading)
		_switch_scene = true
		call_deferred("_deferred_load_scene", path, context)


func load_scene(path: String, context: Dictionary = {}):
	loading = true
	emit_signal("global_loading", loading)
	_switch_scene = false
	#call_deferred("_deferred_load_scene", path, context)
	_deferred_load_scene(path, context)


func clear():
	print("Loading::clear")
	var completed_found := true
	while completed_found:
		completed_found = false
		for index in range(loader_handler_list.size()):
			var loader_handler = loader_handler_list[index]
			if loader_handler.completed:
				loader_handler_list.remove(index)
				completed_found = true
				break


func _next_loader_handler() -> LoaderHandler:
	for handler_loader in loader_handler_list:
		if not handler_loader.completed:
			return handler_loader
	return null


func _deferred_load_scene(path : String, context : Dictionary):
	var loader := ResourceLoader.load_interactive(path)
	if loader == null:
		push_error("Cannot load %s" % path)
		return
	var loader_handler = LoaderHandler.new(path, loader, context)
	loader_handler_list.append(loader_handler)
	total_stage_count += loader.get_stage_count()
	emit_signal("scene_loading", path, context)
	if _switch_scene:
		current_scene.free()
