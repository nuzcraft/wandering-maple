extends Node
class_name LevelGenerator

var rng: RandomNumberGenerator

func _init(rand_num_gen: RandomNumberGenerator) -> void:
	rng = rand_num_gen
	
func generate_level(map: Map, level: int) -> Dictionary:
	var level_dict = {}
	match level:
		1:
			map.size = Vector2i(24, 24)
			map.create_astar()
			var house = map.tile_set.get_pattern(map.PATTERN.HOUSE)
			var house_pos: Vector2i = Vector2i(rng.randi_range(0, 23), rng.randi_range(0, 23))
			map.set_pattern(house_pos, house)
			map.set_solid_cells_from_pattern(house_pos, map.PATTERN.HOUSE)
			for coord in map.get_used_cells():
				map.replicate_for_wrapping(coord)
			level_dict["map"] = map
			level_dict["hero_spawn_coords"] = Vector2i(0, 0)
			var spawn_found: bool = false
			var i = 0
			while i < 100 and not spawn_found:
				spawn_found = true
				var hero_pos = Vector2i(rng.randi_range(0, 23), rng.randi_range(0, 23))
				print("checking point %d, %d" % [hero_pos.x,hero_pos.y])
				for j in range(hero_pos.x - 7, hero_pos.x + 7):
					if not spawn_found: break
					for k in range(hero_pos.y - 7, hero_pos.y + 7):
						if not spawn_found: break
						if map.is_map_pos_solid(Vector2i(j, k)):
							spawn_found = false
							i += 1
							print(hero_pos, " is dead")
				level_dict["hero_spawn_coords"] = hero_pos
		_:
			pass
	return level_dict
