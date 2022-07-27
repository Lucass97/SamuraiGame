extends Control

onready var grid_container = $ColorRect/CenterContainer/VBoxContainer/GridContainer
onready var label =  $ColorRect/CenterContainer/VBoxContainer/Label
onready var http = $HTTPRequest
onready var leaderboard
onready var index_level = 0
onready var levels = ["level1", "level2"]

func _ready():
	
	label.set_text("leaderboard\n" + levels[index_level])
	load_leaderboard(levels[index_level])

func load_leaderboard(level):
	
	reset_grid_container()
	
	Firebase.get_leaderboard("leaderboard-"+ level + "/", http)
	yield(get_tree().create_timer(1.5), "timeout")
	
	var i = 1
	for element in Firebase.leaderboard:
		add_new_entry(str(i), element['user'], element['score'])
		i = i + 1
		
func reset_grid_container():
	for n in grid_container.get_children():
		grid_container.remove_child(n)
		n.queue_free()
	
	var position_label = Label.new()
	var user_label = Label.new()
	var score_label = Label.new()
	
	position_label.text = "posistion "
	user_label.text = "user "
	score_label.text = "score "
	
	grid_container.add_child(position_label)
	grid_container.add_child(user_label)
	grid_container.add_child(score_label)
	
func add_new_entry(position, user, score):
	
	var position_label = Label.new()
	var user_label = Label.new()
	var score_label = Label.new()
	
	position_label.text = position + " "
	user_label.text = user + " "
	score_label.text = score + " "
	
	if user == Firebase.username:
		position_label.add_color_override("font_color", Color.red)
		user_label.add_color_override("font_color", Color.red)
		score_label.add_color_override("font_color", Color.red)
		
	
	grid_container.add_child(position_label)
	grid_container.add_child(user_label)
	grid_container.add_child(score_label)


func _on_Back_pressed():
	return get_tree().change_scene("res://src/UserInterface/Online.tscn")


func _on_Next_pressed():
	
	reset_grid_container()
	
	index_level = index_level + 1
	if index_level > len(levels):
		index_level = 0
	
	label.set_text("leaderboard\n" + levels[index_level])
	
	Firebase.get_leaderboard("leaderboard-"+ levels[index_level] + "/", http)
	yield(get_tree().create_timer(3), "timeout")
	
	var i = 1
	for element in Firebase.leaderboard:
		add_new_entry(str(i), element['user'], element['score'])
		i = i + 1
	
