tool
extends EditorPlugin


func _enter_tree():
	
	add_custom_type("AStarGridVector2", "Node", load("res://addons/astar/vector2/grid_vector2.gd"), null)
	
	add_custom_type("GoapPlanner", "Node", load("res://addons/astar/goap/goap_planner.gd"), null )
	add_custom_type("GoapAction", "Node", load("res://addons/astar/goap/goap_action.gd"), null )
	add_custom_type("GoapActionResource", "Resource", load("res://addons/astar/goap/goap_action_resource.gd"), null)


func _exit_tree():
	
	remove_custom_type("AStarGridVector2")
	
	remove_custom_type("GoapPlanner")
	remove_custom_type("GoapAction")
	remove_custom_type("GoaptActionResource")
