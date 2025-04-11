extends GutTest

var lock_scene = load("res://scenes/lock.tscn")
var lock: Lock

func before_each():
	if lock: lock.free()
	lock = lock_scene.instantiate()

func test_on_confirm_button_pressed():
	watch_signals(lock)
	lock._on_confirm_button_pressed()
	assert_signal_emitted(lock, "confirm")
	lock.free()

func test_on_exit_button_pressed():
	watch_signals(lock)
	lock._on_exit_button_pressed()
	assert_signal_emitted(lock, "exit")
	lock.free()

func test_cycle_tumbler():
	lock._ready()
	lock.tumbler_options = [['a', 'b', 'c'], ['d', 'e', 'f'], ['g', 'h', 'i']]
	var char_0 = lock.cycle_tumbler(0, "down")
	assert_eq(char_0, 'b')
	var char_1 = lock.cycle_tumbler(1, "down")
	assert_eq(char_1, 'e')
	var char_2 = lock.cycle_tumbler(2, "down")
	assert_eq(char_2, 'h')
	char_0 = lock.cycle_tumbler(0, "up")
	assert_eq(char_0, 'a')
	char_1 = lock.cycle_tumbler(1, "up")
	assert_eq(char_1, 'd')
	char_2 = lock.cycle_tumbler(2, "up")
	assert_eq(char_2, 'g')
	var char_3 = lock.cycle_tumbler(20, "up")
	assert_eq(char_3, '', "invalid input returns blank")
	var char_4 = lock.cycle_tumbler(0, "sideways")
	assert_eq(char_4, '', "invalid input returns blank")
	lock.free()
