extends Node2D

@export var seed_string: String

@onready var main_map: Map = $MainMap

# input vars
var press_time: float
var time_to_long_press: float = 0.5
var tile_size: int = 20

# map vars
var camera_size: Vector2i = Vector2i(12, 12)
var rng: RandomNumberGenerator
var level_generator: LevelGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng = RandomNumberGenerator.new()
	if seed_string:
		print('setting seed: %s' % seed_string)
		rng.seed = seed_string.hash()
	#rng.randomize()
	level_generator = LevelGenerator.new(rng)
	# duplicate tilemap for effective wrapping
	var level_dict: Dictionary = level_generator.generate_level(main_map, 1)
	main_map = level_dict["map"]
	$Hero.position = main_map.map_to_local(level_dict["hero_spawn_coords"]) - Vector2(10, 10)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		move_hero(Vector2(-1, 0))
		press_time = 0.0
	elif Input.is_action_just_pressed("right"):
		move_hero(Vector2(1, 0))
		press_time = 0.0
	elif Input.is_action_just_pressed("up"):
		move_hero(Vector2(0, -1))
		press_time = 0.0
	elif Input.is_action_just_pressed("down"):
		move_hero(Vector2(0, 1))
		press_time = 0.0
	elif press_time >= time_to_long_press:
		if Input.is_action_pressed("left"):
			move_hero(Vector2(-1, 0))
		elif Input.is_action_pressed("right"):
			move_hero(Vector2(1, 0))
		elif Input.is_action_pressed("up"):
			move_hero(Vector2(0, -1))
		elif Input.is_action_pressed("down"):
			move_hero(Vector2(0, 1))
		
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") \
		or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		press_time += delta
		
	var hero_map_pos = main_map.local_to_map($Hero.position)
	if hero_map_pos.x < (-main_map.size.x + camera_size.x / 2):
		$Hero.position.x = main_map.map_to_local((main_map.size + camera_size / 2 - Vector2i(1, 1))).x - 10
	elif hero_map_pos.x > (main_map.size.x * 2 - camera_size.x / 2 - 1):
		$Hero.position.x = main_map.map_to_local(-camera_size / 2).x + 10
	elif hero_map_pos.y < (-main_map.size.y + camera_size.y / 2):
		$Hero.position.y = main_map.map_to_local((main_map.size + camera_size / 2 - Vector2i(1, 1))).y - 10
	elif hero_map_pos.y > (main_map.size.y * 2 - camera_size.y / 2 - 1):
		$Hero.position.y = main_map.map_to_local(-camera_size / 2).y + 10

func move_hero(vec: Vector2) -> void:
	match main_map.get_interactable_local_pos($Hero.position + vec * tile_size):
		"door":
			print("door")
		_:
			pass
	
	if main_map.is_local_pos_solid($Hero.position + vec * tile_size):
		print("solid")
	else:
		$Hero.move(vec)	
	
