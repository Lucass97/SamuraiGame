extends KinematicBody2D

onready var damage_area = $DamageArea
onready var damage_timer = $DamageTimer


func _ready():
	damage_area.monitoring=true


func _on_Area2D_body_entered(body):
	
	if body.has_method("player_hit"):
		damage_timer.start()
		damage_area.set_deferred("monitoring", false)
		body.emit_signal("decrease_health")
		body.player_hit(name, global_position)


func _on_DamageTimer_timeout():
	damage_area.monitoring = true
