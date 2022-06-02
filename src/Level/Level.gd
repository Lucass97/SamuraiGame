extends Node2D

const LIMIT_LEFT = -315
const LIMIT_TOP = -250
const LIMIT_RIGHT = 955
const LIMIT_BOTTOM = 690

export var CAMERA_LIMIT = false
export var level_name = "level2"
export var current_stats_path = "user://current_stats.json"
export var stats_path = "user://stats.json"

var time_start = 0

var current_stats = {
	level_name:
		{
			"completed": false,
			"time":"00:00",
			"collected_coins":0,
			"skeletons_killed":0,
			"knights_killed":0,
			"shield_knights_killed":0,
			"archers_killed":0,
			"red_archers_killed":0,
			"yellow_archers_killed":0,
		}
	}
var default_stats = {
			"completed": false,
			"time":"00:00",
			"collected_coins":0,
			"skeletons_killed":0,
			"knights_killed":0,
			"shield_knights_killed":0,
			"archers_killed":0,
			"red_archers_killed":0,
			"yellow_archers_killed":0,
		}

var stats = {}

onready var _win_menu = $"../InterfaceLayer/WinMenu"

func _ready():
	
	_load_stats(stats_path)
	
	for level in stats:
		if level != level_name:
			current_stats[level] = stats[level]
	
	current_stats[level_name] = default_stats
	
	for child in get_children():
		if child is Player:
			var camera = child.get_node("Camera")
			if CAMERA_LIMIT:
				camera.limit_left = LIMIT_LEFT
				camera.limit_top = LIMIT_TOP
				camera.limit_right = LIMIT_RIGHT
				camera.limit_bottom = LIMIT_BOTTOM
	
	
	var _player_path = get_node(@"./Player")
	var _enenemy_archer_path = get_children()
	_player_path.connect("collect_skull", self, "_collect_skull")
	_player_path.connect("collect_coin", self, "_update_current_stats", ["collected_coins"])

	# Prepara i signal per raccogliere le statistiche sui nemici uccisi.
	for child in get_children():
		if child is EnemyArcherEnhancedTypeA:
			child.connect("killed", self, "_update_current_stats", ["red_archers_killed"])
		elif child is EnemyArcherEnhancedTypeB:
			child.connect("killed", self, "_update_current_stats", ["yellow_archers_killed"])
		elif child is EnemyArcher:
			child.connect("killed", self, "_update_current_stats", ["archers_killed"])
		elif child is EnemyKnight:
			child.connect("killed", self, "_update_current_stats", ["knights_killed"])
		elif child is EnemyShield:
			child.connect("killed", self, "_update_current_stats", ["shield_knights_killed"])
		elif child is EnemySkeleton:
			child.connect("killed", self, "_update_current_stats", ["skeletons_killed"])
	
	time_start = OS.get_unix_time()
	
func _collect_skull():
	"""
	Salva il gioco e va nel menu.
	"""
	
	var elapsed = OS.get_unix_time() - time_start
	current_stats[level_name]["completed"] = true
	current_stats[level_name]["time"] = elapsed
	var prev_time = stats[level_name]["time"]
	if prev_time == null:
		 prev_time = 99999999
	if current_stats[level_name]["collected_coins"] > stats[level_name]["collected_coins"]:
		_save_stats(stats_path, current_stats)
	elif current_stats[level_name]["collected_coins"] == stats[level_name]["collected_coins"]:
		if elapsed < int(prev_time) or not current_stats[level_name]["completed"]:
			_save_stats(stats_path, current_stats)
	
	
	_save_stats(current_stats_path, current_stats)
	
	get_tree().paused = true
	_win_menu.open()
	

func _update_current_stats(entity):
	"""
	Aggiorna le statitistiche relative all'entita specificata
	"""
	if entity == "completed" or entity == "time":
		pass
	current_stats[level_name][entity] = int(current_stats[level_name][entity]) + 1
	
func _load_stats(path):
	"""
	Carica le statistiche da disco.
	"""
	var file = File.new()
	file.open(path, File.READ)
	var text = file.get_as_text()
	stats = parse_json(text)
	file.close()

func _save_stats(path, stats_to_save):
	"""
	Salva le statistiche su disco.
	"""
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(stats_to_save))
	file.close()
	
func reset_stats():
	current_stats = default_stats
