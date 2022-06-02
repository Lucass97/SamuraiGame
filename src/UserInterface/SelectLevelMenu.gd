extends Control


export(Vector2) var _start_position = Vector2(0, 360)
export(Vector2) var _end_position = Vector2(0, 380)
export(Vector2) var _start_position2 = Vector2(0, -20)
export(Vector2) var _end_position2 = Vector2(0, 0)
export(float) var fade_in_duration = 0.3
export(float) var fade_out_duration = 0.2

onready var center_cont = $ColorRect/CenterContainer
onready var center_cont2 = $ColorRect/CenterContainer2
onready var scroll_cont = $ColorRect/ScrollContainer
onready var quit_button = center_cont.get_node(@"QuitButton")

onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count() - 1)
onready var tween = $Tween


func _ready():
	#show()
	open()


func close():
	get_tree().paused = false
	# Tween's interpolate_property has these arguments:
	# (Target object, "Property:OptionalSubProperty", From value, To value,
	# Tween duration, Transition type, Easing type, Optional delay)
	tween.interpolate_property(scroll_cont, "modulate:a", 1.0, 0.0,
			fade_out_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(center_cont, "rect_position",
			_end_position, _start_position, fade_out_duration,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(center_cont2, "rect_position",
			_end_position2, _start_position2, fade_out_duration,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()


func open():
	show()
	quit_button.grab_focus()

	tween.interpolate_property(scroll_cont, "modulate:a", 0.0, 1.0,
			fade_in_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(center_cont, "rect_position",
			_start_position, _end_position, fade_in_duration,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(center_cont2, "rect_position",
			_start_position2, _end_position2, fade_in_duration,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()


func _on_QuitButton_pressed():

	if not tween.is_active():
		close()
	
	# wait for 0.3 seconds before change scene
	var t = Timer.new()
	t.set_wait_time(0.3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	get_tree().paused = false
	return get_tree().change_scene("res://src/UserInterface/MainMenu.tscn")


func _on_Tween_tween_all_completed():
	if modulate.a < 0.5:
		hide()
