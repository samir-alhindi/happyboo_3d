class_name Bat extends RigidBody3D

@onready var skin: Node3D = $bat_model
@onready var skin_mesh: MeshInstance3D = $bat_model/Armature/Skeleton3D/bat
@onready var animation_tree: AnimationTree = %AnimationTree

var speed: float
var player: Player
var health: int

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	speed = randf_range(1.0, 2.0)
	health = randi() % 100 + 50

func _physics_process(_delta: float) -> void:
	var direction: Vector3 = global_position.direction_to(player.global_position)
	direction.y = 0
	linear_velocity = direction * speed
	skin.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI


func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("bullet") and health > 0:
		area.queue_free()
		health -= 25
		animation_tree.set("parameters/HurtOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		if health <= 0:
			set_physics_process(false)
			gravity_scale = 1.0
			var dir_away_from_player: Vector3 = - (global_position.direction_to(player.global_position))
			var random_upward_force: Vector3 = Vector3.UP * randf_range(1.0, 5.0)
			apply_central_impulse(dir_away_from_player * 10.0 + random_upward_force)
			lock_rotation = false
			
			await get_tree().create_timer(5.0).timeout
			queue_free()
