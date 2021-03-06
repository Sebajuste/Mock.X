class_name AMap
extends Spatial

var all_points = {}
var astar := AStar.new()


onready var gridmap = $GridMap


func _ready():
	
	add_to_group("amap")
	
	$GridMap.visible = false
	
	var cells = gridmap.get_used_cells()
	for cell in cells:
		var ind = astar.get_available_point_id()
		astar.add_point(ind, gridmap.map_to_world(cell.x, cell.y, cell.z))
		all_points[v3_to_index(cell)] = ind
	for cell in cells:
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				for z in [-1, 0, 1]:
					var v3 = Vector3(x, y, z)
					if v3 == Vector3(0, 0, 0):
						continue
					if v3_to_index(v3 + cell) in all_points:
						var ind1 = all_points[v3_to_index(cell)]
						var ind2 = all_points[v3_to_index(cell + v3)]
						if !astar.are_points_connected(ind1, ind2):
							astar.connect_points(ind1, ind2, true)


func _enter_tree():
	
	NavigationManager.set_navigation( self )
	


func _exit_tree():
	
	NavigationManager.set_navigation( null )
	


func v3_to_index(v3) -> String:
	
	return str(int(round(v3.x))) + "," + str(int(round(v3.y))) + "," + str(int(round(v3.z)))
	


func get_closest_point(to_point : Vector3) -> Vector3:
	
	var point_id = astar.get_closest_point(to_point)
	
	return astar.get_point_position(point_id)
	


func get_simple_path(start : Vector3, end : Vector3) -> PoolVector3Array:
	var gm_start = v3_to_index(gridmap.world_to_map(start))
	var gm_end = v3_to_index(gridmap.world_to_map(end))
	var start_id = 0
	var end_id = 0
	if gm_start in all_points:
		start_id = all_points[gm_start]
	else:
		start_id = astar.get_closest_point(start)
	
	if gm_end in all_points:
		end_id = all_points[gm_end]
	else:
		end_id = astar.get_closest_point(end)
	
	return astar.get_point_path(start_id, end_id)
