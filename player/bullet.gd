extends Area3D

var speed: int = 50
var max_range: float = 200.0
var distance_traveled: float = 0.0

func _physics_process(delta: float) -> void:
	position += -transform.basis.z * speed * delta
	distance_traveled += speed * delta
	if distance_traveled >= max_range:
		queue_free()
