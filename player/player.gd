extends CharacterBody2D

@export var _movement_velocity: float = 128.0

func _physics_process(_delta: float) -> void:
	var direcao = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	
	velocity = direcao * _movement_velocity
	move_and_slide()
