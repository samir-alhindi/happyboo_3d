extends Node3D

@export var object_scene: PackedScene
@export var spawn_rate: float = 5.0

func _ready() -> void:
	%SpawnTimer.wait_time = spawn_rate

func _on_spawn_timer_timeout() -> void:
	var instance: Node3D = object_scene.instantiate()
	%Instances.add_child(instance)
	instance.global_transform = global_transform
	
	if instance is Bat:
		var unique_material = instance.skin_mesh.mesh.surface_get_material(0).duplicate()
		instance.skin_mesh.mesh.surface_set_material(0, unique_material)
