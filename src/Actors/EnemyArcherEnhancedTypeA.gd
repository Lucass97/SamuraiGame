class_name EnemyArcherEnhancedTypeA
extends EnemyArcher


func _ready():
	MAX_HEALTH = 3
	SHOOT_MULTIPLE_ARROW = true
	MAX_CONSECUTIVE_SHOOT = 1
	MAX_FRONT_VISIBILITY = 500
	MAX_BACK_VISIBILITY = 200
	ARROW_COLOR = Color(1,0,0,1)
	speed.x = 150
	_velocity.x = speed.x
	sprite.visible = true
	player_detector_front.cast_to = Vector2(0, MAX_FRONT_VISIBILITY)
	player_detector_back.cast_to = Vector2(0, MAX_BACK_VISIBILITY)
