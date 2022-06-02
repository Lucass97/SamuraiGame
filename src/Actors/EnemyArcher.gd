class_name EnemyArcher
extends Actor

# Rappresenta gli stati in cui si può trovare l'archer.
enum State {
	WALKING,
	DEAD,
	SHOOTING,
	HITTED,
	IDLE,
}

export var MAX_HEALTH = 2

var _state = State.WALKING
var _attack_side = AttackSide.RIGHT
var _health = MAX_HEALTH

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer
onready var attack_timer =  $AttackTimer
onready var cooldown_attack =  $AnimatedSprite/Bow/CooldownAttack
onready var player_detector_front = $RayCast2D
onready var player_detector_back = $RayCastBack
onready var bow = sprite.get_node(@"Bow")

const SPRITE_SCALE = 5
const PLAYER_DETECTOR_SCALE = 1


export var MAX_FRONT_VISIBILITY = 500
export var MAX_BACK_VISIBILITY = 200

export var SHOOT_MULTIPLE_ARROW = false
export var MAX_CONSECUTIVE_SHOOT = 1
var consecutive_shoot = 0

export var ARROW_COLOR = Color(1, 1, 1, 1 )

signal killed_archer()

# Funzione richiamata quando la scena entra nello scene tree.
# Utile per inizializzare variabili.
func _ready():
	speed.x = 150
	_velocity.x = speed.x
	sprite.visible = true
	player_detector_front.cast_to = Vector2(0, MAX_FRONT_VISIBILITY)
	player_detector_back.cast_to = Vector2(0, MAX_BACK_VISIBILITY)


# Funzione richiamata ad ogni frame
func _physics_process(_delta):
	
	# Se il raycast rileva il player e altre condizioni sono soddisfatte entra nello stato SHOOTING
	if player_detector_front.is_colliding():
		var collider = player_detector_front.get_collider()
		if collider.name == "Player" and cooldown_attack.is_stopped():
			_state = State.SHOOTING
			_attack_side = calculate_attack_side(position, collider.position)
	
	_process_velocity()
	_flip_sprite()
	_play_animation()
	

# Funzione che calcola la velocità sulla base dello stato corrente e altri fattori.
func _process_velocity():
	match _state:
		State.HITTED:
			_velocity.y = -400
			if _velocity.x >= 0: 
				_velocity.x = -speed.x
			else:
				 _velocity.x = speed.x
		State.SHOOTING:
			_velocity.x = 0
		State.WALKING:
			if _velocity.x == 0:
				if sprite.scale.x > 0:
					_velocity.x = speed.x
				else: _velocity.x = - speed.x
			if player_detector_back.is_colliding():
				var collider = player_detector_back.get_collider()
				if collider.name == "Player":
					_velocity.x = _attack_side * speed.x
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

func _flip_sprite():
	if attack_timer.is_stopped() and _state != State.SHOOTING: 
		if _velocity.x > 0:
			sprite.scale.x = SPRITE_SCALE
			player_detector_front.scale.y = PLAYER_DETECTOR_SCALE
			player_detector_back.scale.y = PLAYER_DETECTOR_SCALE
		else:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
			sprite.scale.x = -SPRITE_SCALE
			player_detector_front.scale.y = -PLAYER_DETECTOR_SCALE	
			player_detector_back.scale.y = -PLAYER_DETECTOR_SCALE	


# Questa funzione esegue la nuova animazione se e solo se quest'ultima è diversa da quella attuale.
func _play_animation():
	var animation = _get_new_animation()
	if animation != sprite.animation:
		match _state:
			State.SHOOTING:
				attack_timer.start()
				animation_player.stop(true)
				animation_player.play("arrow_sfx")
				sprite.play(animation)
			State.HITTED:
				attack_timer.stop()
				animation_player.queue("hit")
				_state = State.WALKING
			State.DEAD: 
				animation_player.clear_queue()
				animation_player.queue("destroy")
				sprite.play("idle")	
			_: sprite.play(animation)
	if _state == State.DEAD: 
		animation_player.queue("destroy")
		sprite.play("idle")
	

# Questa funzione restituisce una nuova animazione.
func _get_new_animation():
	var animation_new = ""
	match _state:
		State.IDLE:
			animation_new = "idle"
		State.WALKING:
			animation_new = "walk"
		State.SHOOTING:
			animation_new = "shoot"
		State.DEAD:
			animation_new = "destroy"
		_: animation_new = "idle"	
	return animation_new
	
func handle_hit(_who, _position):
	print("Archer: hitted by " + str(_who.name) + " - " + str(_health) + "hp - state: " + str(State.keys()[_state]))
	_state = State.HITTED
	cooldown_attack.start()
	_health -= 1
	if _health <= 0:
		destroy()


func destroy():
	print("Archer: killed")
	self.emit_signal("killed")
	_state = State.DEAD
	
	# Non rilevare più il player.
	player_detector_front.enabled = false
	player_detector_back.enabled = false
	attack_timer.stop()
	cooldown_attack.stop()
	
	

func shoot_arrows():
	bow.shoot(_attack_side, -20)
	bow.shoot(_attack_side, -60)
	bow.shoot(_attack_side, -120)
	
func shoot_arrow():
	var random_number = get_random_number(-120, 0)
	print(_attack_side)
	bow.shoot(_attack_side, random_number)


# Quando il timer relativo all'attack si ferma spara con l'arco e inizia il timer del cooldown.
func _on_AttackTimer_timeout():
	if consecutive_shoot < MAX_CONSECUTIVE_SHOOT:
		consecutive_shoot +=1
		cooldown_attack.wait_time = 0.1
	else:
		consecutive_shoot = 1
		cooldown_attack.wait_time = 0.7
	
	if SHOOT_MULTIPLE_ARROW:
		shoot_arrows()
	else:
		shoot_arrow()
		
	if not cooldown_attack.is_stopped():
		cooldown_attack.stop()
	cooldown_attack.start()
	
	# Riprendi a camminare nella direzione opposta.
	_state = State.WALKING
	match _attack_side:
		AttackSide.LEFT:
			_velocity.x = -speed.x
		AttackSide.RIGHT:
			_velocity.x = speed.x
			
	# Non rilevare più il player.
	player_detector_front.enabled = false
	player_detector_back.enabled = false

# Concluso il timer del cooldown, rileva il player nuovamente.
func _on_CooldownAttack_timeout():
	player_detector_front.enabled = true
	player_detector_back.enabled = true
	_state = State.WALKING
