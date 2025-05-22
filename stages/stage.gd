extends Node



func _on_kill_plane_body_entered(body: Node3D) -> void:
	if body is Player:
		body.global_transform = %SpawnPoint.global_transform
