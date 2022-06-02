class_name Actor
extends KinematicBody2D

# Both the Player and Enemy inherit this scene as they have shared behaviours
# such as speed and are affected by gravity.


export var speed = Vector2(150.0, 350.0)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

# warning-ignore:unused_signal
signal killed()

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

# Indica da quale lato l'attore deve attaccare.
enum AttackSide {
	RIGHT = 1
	LEFT = -1
}

# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
	_velocity.y += gravity * delta

# Funzione che date due posizioni calcola l'attack_side.
func calculate_attack_side(position1, position2):
	if position1.x > position2.x:
		return AttackSide.LEFT
	else: return AttackSide.RIGHT

var rng = RandomNumberGenerator.new()

# Funzione che dati due numeri rappresentanti un range restituisce un numero random.
func get_random_number(x, y):
	return rng.randf_range(x, y)
	

