extends GutTest

# unit test for Hero class
var hero: Hero

func before_all():
	pass
	
func before_each():
	if hero: hero.free()
	hero = Hero.new()
	
func after_each():
	pass
	
func after_all():
	pass
	
func test_tile_size():
	assert_eq(hero.tile_size, 20, 'tile size hard coded to 20')
	hero.free()
	
func test_move():
	hero.position = Vector2(0, 0)
	var new_position = hero.move(Vector2(2, 3))
	assert_eq(new_position, Vector2(40, 60), 'should be input vector x tile size')
	hero.free()
