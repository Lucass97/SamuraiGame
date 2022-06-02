class_name EnemyArcherEnhancedTypeB
extends EnemyArcher


func _ready():
	MAX_HEALTH = 3
	SHOOT_MULTIPLE_ARROW = false
	MAX_CONSECUTIVE_SHOOT = 5
	MAX_FRONT_VISIBILITY = 700
	MAX_BACK_VISIBILITY = 500
	ARROW_COLOR = Color(1,1,0,1)
	speed.x = 150
	_velocity.x = speed.x
	sprite.visible = true
	player_detector_front.cast_to = Vector2(0, MAX_FRONT_VISIBILITY)
	player_detector_back.cast_to = Vector2(0, MAX_BACK_VISIBILITY)
