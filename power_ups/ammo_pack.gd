extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.ammo += 50
		body.powerup_sound.play()
		queue_free()
