extends Node

@onready var game: Node = $".."

func _ready() -> void:
	Global.game_over.connect(
		func(final_score: int):
			%GameOver.show()
			$"../GameOver/ScoreLabel".text = "Score: " + str(final_score)
			game.process_mode = Node.PROCESS_MODE_DISABLED
			game.set_process(false)
			game.set_physics_process(false)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	)

func _on_kill_plane_body_entered(body: Node3D) -> void:
	if body is Player:
		body.health -= 20
		body.global_transform = %SpawnPoint.global_transform

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
