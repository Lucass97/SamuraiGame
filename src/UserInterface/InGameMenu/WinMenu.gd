extends Control


export(Vector2) var _start_position = Vector2(0, -20)
export(Vector2) var _end_position = Vector2.ZERO
export(float) var fade_in_duration = 0.3
export(float) var fade_out_duration = 0.2
export var level_name = "level_name"
export var stats_path = "user://current_stats.json"

onready var center_cont = $ColorRect/CenterContainer
onready var counters = $ColorRect/CenterContainer/VBoxContainer/CenterContainer/GridContainer.get_children()
onready var quit_button = center_cont.get_node(@"VBoxContainer/QuitButton")

onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count() - 1)
onready var tween = $Tween
onready var is_open = false
onready var stats = {}


func _ready():
	hide()


func close():
	is_open = false
	get_tree().paused = false
	# Tween's interpolate_property has these arguments:
	# (Target object, "Property:OptionalSubProperty", From value, To value,
	# Tween duration, Transition type, Easing type, Optional delay)
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0,
			fade_out_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(center_cont, "rect_position",
			_end_position, _start_position, fade_out_duration,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	MusicController.set_volume_db(-15)


func open():
	is_open = true
	show()
	quit_button.grab_focus()

	tween.interpolate_property(self, "modulate:a", 0.0, 1.0,
			fade_in_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(center_cont, "rect_position",
			_start_position, _end_position, fade_in_duration,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	
	_load_stats(stats_path)
	# Impostazioni per ogni counter
	for counter in counters:
		counter.level_name = level_name
		counter.stats = stats
		counter.update_text()
	MusicController.set_volume_db(-20)


func _on_QuitButton_pressed():
	#scene_root.notification(NOTIFICATION_WM_QUIT_REQUEST)
	#get_tree().quit()
	if not tween.is_active():
		close()
	get_tree().paused = false
	return get_tree().change_scene("res://src/UserInterface/MainMenu.tscn")


func _on_Tween_tween_all_completed():
	if modulate.a < 0.5:
		hide()
		
func _load_stats(stats_path_to_load):
	var file = File.new()
	file.open(stats_path_to_load, File.READ)
	var text = file.get_as_text()
	stats = parse_json(text)
	file.close()
