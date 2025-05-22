extends Node3D

@export var object_scene: PackedScene
@export var spawn_rate: float = 5.0

func _ready() -> void:
	%SpawnTimer.wait_time = spawn_rate
	Global.spawn_smoke.connect(
		func(position: Vector3):
			const SMOKE_PUFF: PackedScene = preload("res://assets/mob/smoke_puff/smoke_puff.tscn")
			var smoke: Node3D = SMOKE_PUFF.instantiate()
			%Smoke.add_child(smoke)
			smoke.global_position = position
	)

func _on_spawn_timer_timeout() -> void:
	var instance: Node3D = object_scene.instantiate()
	%Instances.add_child(instance)
	instance.global_position = global_position + Vector3(0, -2, 0)
	
	if instance is Bat:
		var unique_material = instance.skin_mesh.mesh.surface_get_material(0).duplicate()
		instance.skin_mesh.mesh.surface_set_material(0, unique_material)
	
	const SMOKE_PUFF: PackedScene = preload("res://assets/mob/smoke_puff/smoke_puff.tscn")
	var smoke: Node3D = SMOKE_PUFF.instantiate()
	%Smoke.add_child(smoke)
	smoke.global_position = global_position + Vector3(0, -2, 0)
