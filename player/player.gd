class_name Player extends CharacterBody3D

@onready var camera_3d: Camera3D = %Camera3D
@onready var cooldown_timer: Timer = %CooldownTimer
@onready var shooting_point: Marker3D = %ShootingPoint
@onready var bullets: Node = %Bullets
@onready var score_label: Label = %ScoreLabel

@export var speed: int = 5
@export var jump_velocity: int = 5
@export var mouse_sensitivity: float = 0.005

var score: int = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.mob_killed.connect(
		func():
			score += 250
			score_label.text = str(score)
	)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(event.relative.x * mouse_sensitivity * -1)
		var angle: float = event.screen_relative.y * mouse_sensitivity * -1
		camera_3d.rotate_x(angle)
		camera_3d.rotation_degrees.x = clampf(camera_3d.rotation_degrees.x, -80, 80)
	
	if event.is_action_pressed("ui_cancel"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
		const BULLET: PackedScene = preload("res://player/bullet.tscn")
		cooldown_timer.start()
		var bullet: Area3D = BULLET.instantiate()
		bullets.add_child(bullet)
		bullet.global_transform = shooting_point.global_transform
		%ShootSound.play()
		%AnimationPlayer.play("shoot")
	
	
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
