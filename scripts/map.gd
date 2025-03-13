extends TileMapLayer
class_name Map

var size: Vector2i
var astar_grid: AStarGrid2D

enum PATTERN {
	HOUSE,
}

func create_astar() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(Vector2i(-size.x, -size.y), Vector2i(size.x * 3, size.y * 3))
	astar_grid.update()

func replicate_for_wrapping(coord: Vector2i) -> void:
	var src = get_cell_source_id(coord)
	var atl_crd = get_cell_atlas_coords(coord)
	var alt = get_cell_alternative_tile(coord)
	set_cell(coord + Vector2i(-size.x, 0), src, atl_crd, alt)
	set_cell(coord + Vector2i(size.x, 0), src, atl_crd, alt)
	set_cell(coord + Vector2i(0, -size.y), src, atl_crd, alt)
	set_cell(coord + Vector2i(0, size.y), src, atl_crd, alt)
	set_cell(coord + Vector2i(-size.x, -size.y), src, atl_crd, alt)
	set_cell(coord + Vector2i(size.x, size.y), src, atl_crd, alt)
	set_cell(coord + Vector2i(size.x, -size.y), src, atl_crd, alt)
	set_cell(coord + Vector2i(-size.x, size.y), src, atl_crd, alt)
	
func get_solid_cells_from_pattern(pattern: PATTERN) -> Array:
	match pattern:
		PATTERN.HOUSE:
			return [Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, 1), \
					Vector2i(1, 2), Vector2i(2, 1), Vector2i(2, 2)]
		_:
			return []
			
func set_solid_cells_from_pattern(pos: Vector2i, pattern: PATTERN) -> void:
	for cell in get_solid_cells_from_pattern(pattern):
		var coord = pos + cell
		astar_grid.set_point_solid(coord)
		astar_grid.set_point_solid(coord + Vector2i(-size.x, 0))
		astar_grid.set_point_solid(coord + Vector2i(size.x, 0))
		astar_grid.set_point_solid(coord + Vector2i(0, -size.y))
		astar_grid.set_point_solid(coord + Vector2i(0, size.y))
		astar_grid.set_point_solid(coord + Vector2i(-size.x, -size.y))
		astar_grid.set_point_solid(coord + Vector2i(size.x, size.y))
		astar_grid.set_point_solid(coord + Vector2i(size.x, -size.y))
		astar_grid.set_point_solid(coord + Vector2i(-size.x, size.y))
	astar_grid.update()
	
func is_local_pos_solid(local_pos: Vector2) -> bool:
	var map_pos = local_to_map(local_pos)
	return astar_grid.is_point_solid(map_pos)
