class_name EnemyKnight
extends Actor


enum State {
	IDLE,
	WALKING,
	DEAD,
	ATTACKING,
	HITTED,
}

var _state = State.WALKING
var _health = 2
var _attack_side = AttackSide.LEFT

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var player_detector_back = $PlayerDetectorBack
onready var sprite = $AnimatedSprite
onready var collision_box = $CollisionShape2D
onready var detect_area = $AnimatedSprite/DetectArea
onready var animation_player = $AnimationPlayer
onready var attack_timer =  $AttackTimer
onready var cooldown_attack =  $CooldownAttack

const SPRITE_SCALE = 5
const PLAYER_DETECTOR_SCALE = 1
const COLLISION_BOX_SCALE = 1

# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
	_velocity.x = speed.x
	sprite.visible = true


func _physics_process(_delta):
	
	process_velocity()
			
	# We flip the Sprite depending on which way the enemy is moving.
	if attack_timer.is_stopped() and _state != State.ATTACKING: 
		if _velocity.x > 0:
			sprite.scale.x = SPRITE_SCALE
			collision_box.scale.x = COLLISION_BOX_SCALE
			player_detector_back.scale.y = PLAYER_DETECTOR_SCALE
		else:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
			sprite.scale.x = -SPRITE_SCALE
			collision_box.scale.x = -COLLISION_BOX_SCALE
			player_detector_back.scale.y = -PLAYER_DETECTOR_SCALE
	elif _state == State.ATTACKING:
		if _attack_side == AttackSide.LEFT:
			sprite.scale.x = -SPRITE_SCALE
			collision_box.scale.x = -COLLISION_BOX_SCALE
		else: 
			sprite.scale.x = SPRITE_SCALE
			sprite.offset.x = 0
			collision_box.scale.x = COLLISION_BOX_SCALE

	play_animation()

func handle_hit(_who, _position):
	print("Knight: hitted by " + str(_who.name) + " - " + str(_health) + "hp - state: " + str(State.keys()[_state]))
	_state = State.HITTED
	_health -= 1
	if _health <= 0:
		destroy()

func destroy():
	print("Knight: killed")
	self.emit_signal("killed")
	_state = State.DEAD
	_velocity = Vector2.ZERO
	
# Funzione che calcola la velocità sulla base dello stato corrente e altri fattori.
func process_velocity():
	match _state:
		State.HITTED:
			_velocity.y = -400
			if _velocity.x > 0: 
				_velocity.x = -speed.x
			else:
				 _velocity.x = speed.x
		State.ATTACKING:
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
	
func play_animation():
	var animation = get_new_animation()
	if animation != sprite.animation:
		match _state:
			State.ATTACKING:
				animation_player.queue("sword_swing")
				sprite.play(animation)
			State.HITTED:
				animation_player.queue("hit")
				_state = State.WALKING
			State.DEAD:
				animation_player.queue("destroy")
				sprite.play("idle")	
			_:
				sprite.play(animation)
	if _state == State.DEAD: 
		animation_player.play("destroy")
		sprite.play("idle")


func get_new_animation():
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
		_: animation_new = "idle"
		
	return animation_new


func _on_Attack_timeout():
	_state = State.WALKING
	cooldown_attack.start()


func _on_SwordHit_body_entered(body):
	body.emit_signal("decrease_health")
	if body.has_method("player_hit"):
		body.player_hit(name, global_position)


func _on_DetectArea_body_entered(body):
	if body is Player:
		_attack_side = calculate_attack_side(position, body.position)
		_state = State.ATTACKING
		attack_timer.start()
		detect_area.set_deferred("monitoring", false)
		player_detector_back.enabled = false


func _on_CooldownAttack_timeout():
	_state = State.WALKING
	detect_area.set_deferred("monitoring", true)
	player_detector_back.enabled = true

	
