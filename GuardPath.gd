extends Spatial
var all_points = {}
var aS = null
onready var gridmap = $GridMap
func _ready():
	aS = AStar.new()
	var cells = gridmap.get_used_cells()
	for cell in cells:
	    var ind = aS.get_available_point_id()
	    aS.add_point(ind, gridmap.map_to_world(cell.x, cell.y, cell.z))
	    all_points[v3_to_index(cell)] = ind
	for cell in cells:
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				for z in [-1, 0, 1]:
					var v3 = Vector3(x, y, z)
					
