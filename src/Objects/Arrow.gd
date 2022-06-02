class_name Arrow
extends RigidBody2D


onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var deflecting_area = $DeflectingArea
onready var collision_timer = $CollisionTimer
onready var collision_box = $CollisionShape2D
onready var deflected = false

const SPRITE_SCALE = 3
const DEFLECTING_AREA_SCALE = 1
const BULLET_VELOCITY = 700

func _ready():
	sprite.scale.x = SPRITE_SCALE
	collision_box.disabled = false


func _physics_process(_delta):
	if get_linear_velocity().x > 0:
		sprite.scale.x = SPRITE_SCALE
		deflecting_area.scale.x = DEFLECTING_AREA_SCALE
	else: 
		sprite.scale.x = -SPRITE_SCALE
		deflecting_area.scale.x = -DEFLECTING_AREA_SCALE

func destroy():
	animation_player.play("destroy")


func _on_body_entered(body):
	destroy()
	if body is Actor:
		body.destroy()


func deflect():
	print(name + ": deflected")
	deflected = true
	var direction = 1
	if get_linear_velocity().x > 0:
		direction = -1
	else:
		 direction = 1
	set_linear_velocity(Vector2(direction * BULLET_VELOCITY, get_linear_velocity().y))
	set_angular_velocity(0)


func _on_Arrow_body_entered(body):
	collision_box.set_deferred("disabled", true)
	collision_timer.start()
	
	if body.has_method("handle_hit"):
		body.handle_hit(self, position)
	if body.has_method("player_hit") and not deflected:
		body.emit_signal("decrease_health")
		body.player_hit(name, global_position)
	destroy()


func _on_CollisionTimer_timeout():
	collision_box.set_deferred("disabled", false)
