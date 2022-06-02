extends Node2D


var background_music = load("res://assets/audio/music/Slave Knight Gael (8-bit) - Dark Souls III.mp3")
onready var music = $Music

func _ready():
	$Music.stream = background_music

func play_music():
	if not $Music.is_playing():
		$Music.play()
	
func stop_music():
	$Music.stop()
	
func set_volume_db(db):
	$Music.set_volume_db(db)
