class_name EnemySkeleton
extends Actor


enum State {
	WALKING,
	DEAD,
	HITTED,
	IDLE,
	ATTACKING,
}

var _state = State.WALKING

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var player_detector_back = $PlayerDetectorBack
onready var damage_area = $DamageArea
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer
onready var cooldown_attack =  $CooldownAttack

const SPRITE_SCALE = 5
const PLAYER_DETECTOR_SCALE = 1


func _ready():
	speed.x = 200
	_velocity.x = speed.x
	sprite.visible = true


func _physics_process(_delta):
	
	_process_velocity()
	_flip_sprite()
	_play_animation()

# Funzione che calcola la velocità sulla base dello stato corrente e altri fattori.
func _process_velocity():
	match _state:
		State.HITTED:
			_velocity.y = -400
			if _velocity.x > 0: 
				_velocity.x = -speed.x
			else:
				 _velocity.x = speed.x
		State.WALKING:
			if _velocity.x == 0:
				if sprite.scale.x > 0:
					_velocity.x = -speed.x
				else: _velocity.x = speed.x
			if player_detector_back.is_colliding():
				var collider = player_detector_back.get_collider()
				if collider.name == "Player":
					_velocity.x = -_velocity.x
			if not floor_detector_left.is_colliding():
				_velocity.x = speed.x
			elif not floor_detector_right.is_colliding():
				_velocity.x = -speed.x
		State.IDLE:
			_velocity.x = 0
		State.DEAD:
			_velocity = Vector2.ZERO
	
	if is_on_wall():
		_velocity.x *= -1

	# We only update the y value of _velocity as we want to handle the horizontal movement ourselves.
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	
func _play_animation():
	var animation = _get_new_animation()
	if animation != sprite.animation:
		match _state:
			State.HITTED:
				animation_player.queue("hit")
				_state = State.WALKING
			State.DEAD: 
				animation_player.queue("destroy")
				sprite.play("idle")	
			_:
				sprite.play(animation)
	if _state == State.DEAD: 
		animation_player.queue("destroy")
		sprite.play("idle")

func _get_new_animation():
	var animation_new = ""
	match _state:
		State.IDLE:
			animation_new = "idle"
		State.WALKING:
			animation_new = "walk"
		State.DEAD:
			animation_new = "destroy"
		_: animation_new = "idle"
		
	return animation_new

# Funzione che orienta la sprite e eventualmente gli altri collisori dell'entity
func _flip_sprite():
	if _velocity.x > 0:
		sprite.scale.x = SPRITE_SCALE
		player_detector_back.scale.y = PLAYER_DETECTOR_SCALE
	else:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
		sprite.scale.x = -SPRITE_SCALE
		player_detector_back.scale.y =  -PLAYER_DETECTOR_SCALE

func handle_hit(_who, _position):
	print("Skeleton: hitted by " + str(_who.name) + " - state: " + str(State.keys()[_state]))
	_velocity.y = -400
	_velocity.x = -_velocity.x 
	destroy()

func destroy():
	print("Skeleton: Killed")
	self.emit_signal("killed")
	_state = State.DEAD
	damage_area.set_deferred("monitoring", false)
	_velocity = Vector2.ZERO
	

func _on_DamageArea_body_entered(body):
	if body.has_method("player_hit") and cooldown_attack.is_stopped():
		body.emit_signal("decrease_health")
		body.player_hit(name, global_position)
		cooldown_attack.start()
		damage_area.set_deferred("monitoring", false)
		player_detector_back.enabled=false
		


func _on_CooldownAttack_timeout():
	damage_area.set_deferred("monitoring", true)
	player_detector_back.enabled=true
