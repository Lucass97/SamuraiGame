extends Node


onready var default_stats = {
   "level1":{
	  "archers_killed":0,
	  "collected_coins":0,
	  "completed":false,
	  "knights_killed":0,
	  "red_archers_killed":0,
	  "shield_knights_killed":0,
	  "skeletons_killed":0,
	  "time":null,
	  "yellow_archers_killed":0
	 },
	 "level2":{
	  "archers_killed":0,
	  "collected_coins":0,
	  "completed":false,
	  "knights_killed":0,
	  "red_archers_killed":0,
	  "shield_knights_killed":0,
	  "skeletons_killed":0,
	  "time":null,
	  "yellow_archers_killed":0
	 }
}

onready var record_stats = {}
onready var current_stats = {}

func _ready():
	var dir = Directory.new()
	dir.make_dir("data/org.godot.samuraigame")
	if not check_files_path("user://stats.json"):
		_save_stats("user://stats.json", default_stats)
	if not check_files_path("user://current_stats.json"):
		_save_stats("user://current_stats.json", default_stats)
		
	load_record_stats("user://stats.json")
	reset_current_stats()
	reset_record_stats()
	
	print(current_stats)


func check_files_path(path):
	var file2Check = File.new()
	return file2Check.file_exists(path)	
	
func save_record_stats():
	_save_stats("user://stats.json", record_stats)

func save_current_stats():
	_save_stats("user://stats.json", current_stats)
		
func _save_stats(path, stats_to_save):
	"""
	Salva le statistiche su disco.
	"""
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(stats_to_save))
	file.close()	
	
func load_record_stats(path):
	"""
	Carica le statistiche da disco.
	"""
	
	var file = File.new()
	file.open(path, File.READ)
	var text = file.get_as_text()
	record_stats = parse_json(text)
	file.close()
	
func reset_current_stats():
	current_stats = default_stats.duplicate(true)
	
func reset_record_stats():
	record_stats = default_stats.duplicate(true)

func update_current_stats(level, entity):
	"""
	Aggiorna le statitistiche relative all'entita specificata
	"""
	if entity == "completed" or entity == "time":
		pass
	current_stats[level][entity] = int(current_stats[level][entity]) + 1

func complete_level(level, elapsed):
	
	current_stats[level]["completed"] = true
	current_stats[level]["time"] = elapsed
	

func register_current_stats(level):
	
	var record_score = get_score(level, record_stats)
	var current_score = get_score(level, current_stats)
	
	if current_score > record_score:
		record_stats[level] = current_stats[level]
		
		

			
func get_score(level, stats):
	
	if stats[level]["completed"] == false:
		return 0
	
	var total = 300 - int(stats[level]["time"])
	if total <= 0:
		total = 0
		
	total = total + int(stats[level]["collected_coins"]) * 100
	total = total + int(stats[level]["skeletons_killed"]) * 20
	total = total + int(stats[level]["knights_killed"]) * 50
	total = total + int(stats[level]["shield_knights_killed"]) * 100
	total = total + int(stats[level]["archers_killed"]) * 50
	total = total + int(stats[level]["yellow_archers_killed"]) * 100
	total = total + int(stats[level]["red_archers_killed"]) * 150
	
	return total
