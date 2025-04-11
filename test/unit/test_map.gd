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
	
func test_set_solid_cells_from_pattern():
	map.size = Vector2(5, 5)
	map.create_astar()
	var solid_cells = map.get_solid_cells_from_pattern(map.PATTERN.HOUSE)
	map.set_solid_cells_from_pattern(Vector2i(0, 0), map.PATTERN.HOUSE)
	for cell in solid_cells:
		for x in [-map.size.x, 0, map.size.x]:
			for y in [-map.size.y, 0, map.size.y]:
				assert_true(map.astar_grid.is_point_solid(cell + Vector2i(x, y)), 'should be solid at %d, %d' % [cell.x + x, cell.y + y])
	map.free()

func test_is_map_pos_solid():
	map.size = Vector2(2, 2)
	map.create_astar()
	map.astar_grid.set_point_solid(Vector2i(1, 1))
	assert_true(map.is_map_pos_solid(Vector2i(1, 1)))
	assert_false(map.is_map_pos_solid(Vector2i(0, 0)))
	map.free()
	
func test_interactable_init():
	var interactable: Map.Interactable = map.Interactable.new("interactable", Vector2i(1, 2))
	assert_eq(interactable.name, "interactable")
	assert_eq(interactable.map_coords, Vector2i(1, 2))
	map.free()
	
func test_get_interactable_from_pattern():
	var house_interactables: Array[Map.Interactable] = map.get_interactables_from_pattern(map.PATTERN.HOUSE)
	assert_eq(house_interactables[0].name, "door")
	assert_eq(house_interactables[0].map_coords, Vector2i(1, 2))
	assert_eq(map.get_interactables_from_pattern(-1), [])
	map.free()

func test_get_interactable_map_pos():
	map.size = Vector2(5, 5)
	map.set_interactables_from_pattern(Vector2i(1, 2), map.PATTERN.HOUSE)
	var interactable: Map.Interactable = map.get_interactables_from_pattern(map.PATTERN.HOUSE)[0]
	assert_eq(map.get_interactable_map_pos(Vector2i(1, 2) + interactable.map_coords), interactable.name)
	map.free()
	pass
	
func test_set_interactables_from_pattern():
	map.size = Vector2(5, 5)
	var house_interactables: Array[Map.Interactable] = map.get_interactables_from_pattern(map.PATTERN.HOUSE)
	map.set_interactables_from_pattern(Vector2i(0, 0), map.PATTERN.HOUSE)
	for i in house_interactables:
		for x in [-map.size.x, 0, map.size.x]:
			for y in [-map.size.y, 0, map.size.y]:
				var coord: Vector2i = i.map_coords + Vector2i(x, y)
				assert_eq(map.get_interactable_map_pos(coord), i.name)
	map.free()
