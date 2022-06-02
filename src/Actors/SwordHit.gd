extends Area2D


func _on_SwordHit_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit(get_parent().get_parent(), global_position)
	if body.has_method("deflect"):
		body.deflect()
