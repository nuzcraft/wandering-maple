extends TileMapLayer
class_name Map

var size: Vector2i

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
