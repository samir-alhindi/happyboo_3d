extends Node3D

@onready var spawn_timer: Timer = %SpawnTimer

@export var object_scene: PackedScene
@export var min_spawn_rate: float = 5.0
@export var max_spawn_rate: float = 10.0
@export var color: Color
@export var only_one: bool = false

func _ready() -> void:
	randomize()
	%SpawnTimer.wait_time = randf_range(min_spawn_rate, max_spawn_rate)
	var mat_copy: StandardMaterial3D = $spawner_model/Body.get_surface_override_material(0).duplicate()
	mat_copy.albedo_color = color
	$spawner_model/Body.set_surface_override_material(0, mat_copy)
	Global.spawn_smoke.connect(
		func(position: Vector3):
			const SMOKE_PUFF: PackedScene = preload("res://assets/mob/smoke_puff/smoke_puff.tscn")
			var smoke: Node3D = SMOKE_PUFF.instantiate()
			%Smoke.add_child(smoke)
			smoke.global_position = position
	)

func _on_spawn_timer_timeout() -> void:
	
	if only_one and %Instances.get_children().size() > 0:
		return
	
	spawn_timer.wait_time = randf_range(min_spawn_rate, max_spawn_rate)
	var instance: Node3D = object_scene.instantiate()
	%Instances.add_child(instance)
	instance.global_position = global_position + Vector3(0, -3, 0)
	
	if instance is Bat:
		var unique_material = instance.skin_mesh.mesh.surface_get_material(0).duplicate()
		instance.skin_mesh.mesh.surface_set_material(0, unique_material)
	
	const SMOKE_PUFF: PackedScene = preload("res://assets/mob/smoke_puff/smoke_puff.tscn")
	var smoke: Node3D = SMOKE_PUFF.instantiate()
	%Smoke.add_child(smoke)
	smoke.global_position = global_position + Vector3(0, -3, 0)
