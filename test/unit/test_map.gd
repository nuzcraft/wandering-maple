extends GutTest
# unit testing for new Map functionality

const BASE_TILESET = preload("res://resources/base_tileset.tres")
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
	
func test_replicate_for_wrapping():
	map.size = Vector2(2, 2)
	map.tile_set = BASE_TILESET
	var original_coords: Vector2i = Vector2i(1, 2)
	var original_source: int = 0
	var original_atlas_coords: Vector2i = Vector2i(1, 0)
	var original_alternative_tile: int = 0
	map.set_cell(original_coords, original_source, original_atlas_coords, original_alternative_tile)
	map.replicate_for_wrapping(original_coords)
	for x in [-map.size.x, 0, map.size.x]:
		for y in [-map.size.y, 0, map.size.y]:
				assert_eq(map.get_cell_source_id(original_coords + Vector2i(x, y)), original_source)
	map.free()
	
func test_get_solid_cells_from_pattern():
	var house_cells = [Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, 1), \
					Vector2i(1, 2), Vector2i(2, 1), Vector2i(2, 2)]
	assert_eq(map.get_solid_cells_from_pattern(map.PATTERN.HOUSE), house_cells)
	assert_eq(map.get_solid_cells_from_pattern(-1), [])
	map.free()
	
	
