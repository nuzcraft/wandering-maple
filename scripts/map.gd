extends TileMapLayer
class_name Map

var size: Vector2i
var astar_grid: AStarGrid2D
var interactables: Array[Interactable]

enum PATTERN {
	UNKNOWN = -1,
	HOUSE,
}

class Interactable:
	var name: String
	var map_coords: Vector2i
	
	func _init(name_str: String, coords: Vector2i) -> void:
		name = name_str
		map_coords = coords

func create_astar() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(Vector2i(-size.x, -size.y), Vector2i(size.x * 3, size.y * 3))
	astar_grid.update()

func replicate_for_wrapping(coord: Vector2i) -> void:
	var src = get_cell_source_id(coord)
	var atl_crd = get_cell_atlas_coords(coord)
	var alt = get_cell_alternative_tile(coord)
	for x in [-size.x, 0, size.x]:
		for y in [-size.y, 0, size.y]:
			var new_coord: Vector2i = coord + Vector2i(x, y)
			if new_coord != coord:
				set_cell(new_coord, src, atl_crd, alt)
	
func get_solid_cells_from_pattern(pattern: PATTERN) -> Array[Vector2i]:
	match pattern:
		PATTERN.HOUSE:
			return [Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, 1), \
					Vector2i(1, 2), Vector2i(2, 1), Vector2i(2, 2)]
		_:
			return []
			
func set_solid_cells_from_pattern(pos: Vector2i, pattern: PATTERN) -> void:
	for cell in get_solid_cells_from_pattern(pattern):
		for x in [-size.x, 0, size.x]:
			for y in [-size.y, 0, size.y]:
				var coord: Vector2i = pos + cell + Vector2i(x, y)
				astar_grid.set_point_solid(coord)
	astar_grid.update()
	
func get_interactables_from_pattern(pattern: PATTERN) -> Array[Interactable]:
	match pattern:
		PATTERN.HOUSE:
			var door = Interactable.new("door", Vector2i(1, 2))
			return [door]
		_:
			return []

func set_interactables_from_pattern(pos: Vector2i, pattern: PATTERN) -> void:
	for thing in get_interactables_from_pattern(pattern):
		for x in [-size.x, 0, size.x]:
			for y in [-size.y, 0, size.y]:
				var thing_name: String = thing.name
				var coord: Vector2i = pos + thing.map_coords + Vector2i(x, y)
				var new_interactable = Interactable.new(thing_name, coord)
				interactables.append(new_interactable)
	
func is_local_pos_solid(local_pos: Vector2) -> bool:
	var map_pos = local_to_map(local_pos)
	return is_map_pos_solid(map_pos)
	
func is_map_pos_solid(map_pos: Vector2i) -> bool:
	return astar_grid.is_point_solid(map_pos)
	
func get_interactable_local_pos(local_pos: Vector2) -> String:
	var map_pos = local_to_map(local_pos)
	return get_interactable_map_pos(map_pos)

func get_interactable_map_pos(map_pos: Vector2i) -> String:
	for i in interactables:
		if i.map_coords == map_pos:
			return i.name
	return ""
