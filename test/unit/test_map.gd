extends GutTest
# unit testing for new Map functionality

var map: Map

func before_each():
	if map: map.free()
	map = Map.new()

func test_create_astar():
	map.size = Vector2(2, 3)
	map.create_astar()
	assert_eq(map.astar_grid.region.position, Vector2i(-2, -3), 'astar region starts at (-size.x, -size.y)')
	assert_eq(map.astar_grid.size, Vector2i(6, 9), 'astar should be 3x map size')
	map.free()
	
