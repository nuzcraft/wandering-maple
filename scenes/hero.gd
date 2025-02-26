extends Node2D
class_name Hero

var tile_size: int = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move(vec: Vector2) -> Vector2:
	position += vec * tile_size
	return position
