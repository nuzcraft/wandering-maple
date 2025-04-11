extends Control

signal confirm
signal exit

@onready var tumbler_options: = \
	[['a', 'b', 'c'], \
	['d', 'e', 'f'], \
	['g', 'h', 'i']]

@onready var lock_h_box_container: HBoxContainer = $VBoxContainer/LockHBoxContainer

func _ready() -> void:
	var tumbler_num: int = 0
	for tumbler_container in lock_h_box_container.get_children():
		if tumbler_container is VBoxContainer:
			tumbler_container.get_node("Label").text = tumbler_options[tumbler_num][0]
			tumbler_num += 1

func _on_confirm_button_pressed() -> void:
	print("confirm pressed")
	confirm.emit()

func _on_exit_button_pressed() -> void:
	print("exit pressed")
	exit.emit()

func _on_up_button_pressed(extra_arg_0: String) -> void:
	#print(extra_arg_0) #should be like "Tumbler1"
	var i: int = int(extra_arg_0.replace("Tumbler", "")) - 1
	cycle_tumbler(i, "up")

func _on_down_button_pressed(extra_arg_0: String) -> void:
	#print(extra_arg_0) #should be like "Tumbler1"
	var i: int = int(extra_arg_0.replace("Tumbler", "")) - 1
	cycle_tumbler(i, "down")
	
func cycle_tumbler(num: int, direction: String) -> String:
	var tumbler_num: int = 0
	for tumbler_container in lock_h_box_container.get_children():
		if tumbler_container is VBoxContainer:
			if tumbler_num != num:
				tumbler_num += 1
				continue
			else:
				for j in len(tumbler_options[num]):
					if tumbler_container.get_node("Label").text == tumbler_options[num][j]:
						if direction == "up":
							if j == 0:
								tumbler_container.get_node("Label").text = tumbler_options[num][len(tumbler_options[num]) - 1]
							else:
								tumbler_container.get_node("Label").text = tumbler_options[num][j - 1]
						else: 
							if j == len(tumbler_options[num]) - 1:
								tumbler_container.get_node("Label").text = tumbler_options[num][0]
							else:
								tumbler_container.get_node("Label").text = tumbler_options[num][j + 1]
						break
				return tumbler_container.get_node("Label").text
	return ""
