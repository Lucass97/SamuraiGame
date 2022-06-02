extends Node

export var level_name = "level_name"
export var entity = "entity_name"

export onready var stats = {}
onready var label = $Label


func _ready():
	pass

func update_text():
	if entity == "completed":
		if not stats[level_name][entity]:
			self.visible = false
		return
		
	if stats.has(level_name):
		if entity == "time":
			var time = stats[level_name]["time"]
			if time:
				var minutes = float(stats[level_name]["time"]) / 60
				var seconds = int(stats[level_name]["time"]) % 60
				time = "%02d:%02d" % [minutes, seconds]
				label.set_text(time)
			else:
				label.set_text("NaN")
		else:
			label.set_text(str(stats[level_name][entity]))
