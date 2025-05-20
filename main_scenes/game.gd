extends Node

@onready var spawn_point: Marker3D = %SpawnPoint
@onready var enemy_spawn_timer: Timer = %EnemySpawnTimer


func _on_enemy_spawn_timer_timeout() -> void:
	const BAT: PackedScene = preload("res://enemies/bat/bat.tscn")
	var bat: RigidBody3D = BAT.instantiate()
	spawn_point.add_child(bat)
	bat.global_position = spawn_point.global_position
