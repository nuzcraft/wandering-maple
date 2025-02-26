extends Node2D

# input vars
var press_time: float
var time_to_long_press: float = 0.5

# map vars
var map_size: Vector2 = Vector2(24, 24)
var camera_size: Vector2 = Vector2(12, 12)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# duplicate tilemap for effective wrapping
	for coord in $TileMapLayer.get_used_cells():
		var src = $TileMapLayer.get_cell_source_id(coord)
		var atl_crd = $TileMapLayer.get_cell_atlas_coords(coord)
		var alt = $TileMapLayer.get_cell_alternative_tile(coord)
		$TileMapLayer.set_cell(coord + Vector2i(-map_size.x, 0), src, atl_crd, alt)
		$TileMapLayer.set_cell(coord + Vector2i(map_size.x, 0), src, atl_crd, alt)
		$TileMapLayer.set_cell(coord + Vector2i(0, -map_size.y), src, atl_crd, alt)
		$TileMapLayer.set_cell(coord + Vector2i(0, map_size.y), src, atl_crd, alt)
		$TileMapLayer.set_cell(coord + Vector2i(-map_size.x, -map_size.y), src, atl_crd, alt)
		$TileMapLayer.set_cell(coord + Vector2i(map_size.x, map_size.y), src, atl_crd, alt)
		$TileMapLayer.set_cell(coord + Vector2i(map_size.x, -map_size.y), src, atl_crd, alt)
		$TileMapLayer.set_cell(coord + Vector2i(-map_size.x, map_size.y), src, atl_crd, alt)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		$Hero.move(Vector2(-1, 0))
		press_time = 0.0
	elif Input.is_action_just_pressed("right"):
		$Hero.move(Vector2(1, 0))
		press_time = 0.0
	elif Input.is_action_just_pressed("up"):
		$Hero.move(Vector2(0, -1))
		press_time = 0.0
	elif Input.is_action_just_pressed("down"):
		$Hero.move(Vector2(0, 1))
		press_time = 0.0
	elif press_time >= time_to_long_press:
		if Input.is_action_pressed("left"):
			$Hero.move(Vector2(-1, 0))
		elif Input.is_action_pressed("right"):
			$Hero.move(Vector2(1, 0))
		elif Input.is_action_pressed("up"):
			$Hero.move(Vector2(0, -1))
		elif Input.is_action_pressed("down"):
			$Hero.move(Vector2(0, 1))
		
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") \
		or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		press_time += delta
		
	var hero_map_pos = $TileMapLayer.local_to_map($Hero.position)
	if hero_map_pos.x < (-map_size.x + camera_size.x / 2):
		$Hero.position.x = $TileMapLayer.map_to_local((map_size + camera_size / 2 - Vector2(1, 1))).x - 10
	elif hero_map_pos.x > (map_size.x * 2 - camera_size.x / 2 - 1):
		$Hero.position.x = $TileMapLayer.map_to_local(-camera_size / 2).x + 10
	elif hero_map_pos.y < (-map_size.y + camera_size.y / 2):
		$Hero.position.y = $TileMapLayer.map_to_local((map_size + camera_size / 2 - Vector2(1, 1))).y - 10
	elif hero_map_pos.y > (map_size.y * 2 - camera_size.y / 2 - 1):
		$Hero.position.y = $TileMapLayer.map_to_local(-camera_size / 2).y + 10
	
	
