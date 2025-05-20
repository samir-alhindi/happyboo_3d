extends Area3D

var speed: int = 50

func _physics_process(delta: float) -> void:
	position += -transform.basis.z * speed * delta
