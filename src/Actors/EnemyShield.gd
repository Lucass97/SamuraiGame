class_name EnemyShield
extends Actor

# Rappresenta gli stati in cui si può trovare l'enemShield.
enum State {
	IDLE,
	WALKING,
	DEAD,
	ATTACKING,
	HITTED,
	DEFENDING,
}

var _state = State.WALKING
var _health = 3
var _attack_side = AttackSide.LEFT

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $AnimatedSprite
onready var collision = $CollisionShape2D
onready var animation_player = $AnimationPlayer
onready var animation_player_only_sfx = $AnimationPlayerOnlySFX
onready var attack_timer =  $AttackTimer
onready var cooldown_defende = $CooldownDefende
onready var random_attack_timer = $RandomAttackTimer
onready var stamina_timer = $StaminaTimer
onready var player_detector_back = $PlayerDetectorBack
onready var detect_area =  $AnimatedSprite/DetectArea

const SPRITE_SCALE = 5
const PLAYER_DETECTOR_SCALE = 1

export var MIN_TEMP_FOR_RANDOM_ATTACK = 3
export var MAX_TEMP_FOR_RANDOM_ATTACK = 6
export var DEFAULT_MIN_TEMP_FOR_RANDOM_ATTACK = 0.3
export var DEFAULT_MAX_TEMP_FOR_RANDOM_ATTACK = 1.5
var CURRENT_MIN_TEMP_FOR_RANDOM_ATTACK = DEFAULT_MIN_TEMP_FOR_RANDOM_ATTACK
var CURRENT_MAX_TEMP_FOR_RANDOM_ATTACK = DEFAULT_MAX_TEMP_FOR_RANDOM_ATTACK
export var EPSILON_TEMP_RANDOM_ATTACK = 0.4

enum AttackType {
	NONE,
	COUNTER_ATTACK,
	RANDOM_ATTACK
}

var _last_attack = AttackType.NONE


func _ready():
	speed.x = 100
	_velocity.x = speed.x
	sprite.visible = true
	detect_area.monitoring = true


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
		State.ATTACKING:
			_velocity.x = 0
		State.DEFENDING:
			_velocity.x = 0
		State.WALKING:
			if _velocity.x == 0:
				if sprite.scale.x > 0:
					_velocity.x = speed.x
				else: _velocity.x = - speed.x
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

	
func _flip_sprite():
	if attack_timer.is_stopped() and _state != State.DEFENDING: 
		if _velocity.x > 0:
			sprite.scale.x = SPRITE_SCALE
			player_detector_back.scale.y = PLAYER_DETECTOR_SCALE
		else:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
			sprite.scale.x = -SPRITE_SCALE
			player_detector_back.scale.y =  -PLAYER_DETECTOR_SCALE
	elif _state == State.DEFENDING or _state == State.ATTACKING:
		if _attack_side == AttackSide.LEFT:
			sprite.scale.x = -SPRITE_SCALE
		else: sprite.scale.x = SPRITE_SCALE
	

func _play_animation():
	var animation = _get_new_animation()
	if animation != sprite.animation:
		match _state:
			State.ATTACKING:
				attack_timer.start()
				animation_player.queue("sword_swing")
				sprite.play(animation)
			State.HITTED:
				attack_timer.stop()
				random_attack_timer.stop()
				animation_player.queue("hit")
				_state = State.WALKING
			State.DEAD: 
				animation_player.queue("destroy")
				sprite.play("idle")	
			State.DEFENDING:
				sprite.play("defende")	
			_: sprite.play(animation)
	if _state == State.DEAD: 
		animation_player.play("destroy")
		sprite.play("idle")
	

func _get_new_animation():
	var animation_new = ""
	match _state:
		State.IDLE:
			animation_new = "idle"
		State.WALKING:
			animation_new = "walk"
		State.ATTACKING:
			animation_new = "attack"
		State.DEAD:
			animation_new = "destroy"
		State.DEFENDING:
			animation_new = "defende"
		_: animation_new = "idle"
		
	return animation_new
	
	
func handle_hit(who, position):
	print("Shield Knight: hitted by " + str(who.name) + " - " + str(_health) + "hp - state: " + str(State.keys()[_state]))
	match _state:
		# Se colpito mentre si sta nello stato di difesa allora contrattacca.
		State.DEFENDING:
			var from_side = calculate_attack_side(global_position, position)
			player_detector_back.enabled = false
			detect_area.monitoring = false
			# In caso di contrattacco il recupero d più lungo
			cooldown_defende.wait_time = 1
			if who.name == "Player" and from_side == _attack_side:
				attack_timer.start()
				_state = State.ATTACKING
				_last_attack = AttackType.COUNTER_ATTACK
				#animation_player.queue("shield_hit")
			elif who.name == "Player" and from_side != _attack_side:
				_get_hitted()
			elif who.name == "Arrow" and from_side == _attack_side:
				who.has_method("deflect")
				who.deflect()
			elif who.name == "Arrow" and from_side != _attack_side:
				_get_hitted()
		# Se colpito in qualsiasi altro stato allora prende il colpo.
		_:	
			_get_hitted()

func _get_hitted():
	_state = State.HITTED
	_health -= 1
	if _health <= 0:
		destroy()

func destroy():
	print("Shield Knight: killed")
	self.emit_signal("killed")
	_state = State.DEAD
	_velocity = Vector2.ZERO


func _on_SwordHit_body_entered(body):
	if body.has_method("player_hit"):
		animation_player_only_sfx.play("sword_hit_shield")
		body.emit_signal("decrease_health")
		body.player_hit(name, global_position)


func _on_CooldownDefende_timeout():
	# Al termine del cooldown torna offensivo.
	player_detector_back.enabled = true
	detect_area.monitoring = true
	
	if _last_attack == AttackType.RANDOM_ATTACK:
		_state = State.WALKING


func _on_AttackTimer_timeout():
	player_detector_back.enabled = false
	detect_area.monitoring = false
	cooldown_defende.start()
	
	# Se l'ultimo attacco subito è un RANDOM_ATTACK allora rimani sulla difensiva.
	if _last_attack == AttackType.RANDOM_ATTACK:
		_state = State.DEFENDING
	else:
		_state = State.WALKING


func _on_DetectArea_body_entered(body):
	if(body.name == "Player") and cooldown_defende.is_stopped() and _state != State.ATTACKING:
		_attack_side = calculate_attack_side(position, body.position)
		_state = State.DEFENDING
		random_attack_timer.start()


func _on_DetectArea_body_exited(_body):
	if _state != State.ATTACKING:
		_state = State.WALKING
		random_attack_timer.wait_time = get_random_number(MIN_TEMP_FOR_RANDOM_ATTACK, MAX_TEMP_FOR_RANDOM_ATTACK)
		random_attack_timer.stop()
	

func _on_RandomAttackTimer_timeout():
	# In caso di attacco random poniamo il recupero deve essere veloce.
	cooldown_defende.wait_time = 0.01
	
	# Gli attacchi random futuri saranno più sporadici.
	CURRENT_MAX_TEMP_FOR_RANDOM_ATTACK += EPSILON_TEMP_RANDOM_ATTACK
	CURRENT_MIN_TEMP_FOR_RANDOM_ATTACK += EPSILON_TEMP_RANDOM_ATTACK
	if CURRENT_MAX_TEMP_FOR_RANDOM_ATTACK >= MAX_TEMP_FOR_RANDOM_ATTACK:
		CURRENT_MAX_TEMP_FOR_RANDOM_ATTACK = MAX_TEMP_FOR_RANDOM_ATTACK
	if CURRENT_MIN_TEMP_FOR_RANDOM_ATTACK >= MIN_TEMP_FOR_RANDOM_ATTACK:
		CURRENT_MIN_TEMP_FOR_RANDOM_ATTACK = MIN_TEMP_FOR_RANDOM_ATTACK
	random_attack_timer.wait_time = get_random_number(CURRENT_MIN_TEMP_FOR_RANDOM_ATTACK, CURRENT_MAX_TEMP_FOR_RANDOM_ATTACK)
	
	# Fai partire il timer della stamina e se eventualmente era già partito fermalo.
	if not stamina_timer.is_stopped():
		stamina_timer.stop()
	stamina_timer.start()
	
	_last_attack = AttackType.RANDOM_ATTACK
	_state = State.ATTACKING
	attack_timer.start()


func _on_DetectArrowArea_area_entered(area):
	if _state != State.DEFENDING:
		_attack_side = calculate_attack_side(area.position, position)
		_state = State.DEFENDING


func _on_DetectArrowArea_area_exited(_area):
	_state = State.WALKING


func _on_StaminaTimer_timeout():
	# Quando il nemico recupera la stamina può attaccare più spesso.
	CURRENT_MAX_TEMP_FOR_RANDOM_ATTACK = DEFAULT_MAX_TEMP_FOR_RANDOM_ATTACK
	CURRENT_MIN_TEMP_FOR_RANDOM_ATTACK = DEFAULT_MIN_TEMP_FOR_RANDOM_ATTACK

