extends CharacterBody2D

@export var _movement_velocity: float = 128.0
@export var _player_animator: AnimationPlayer

var _animation_suffix: String = "_down"

func _physics_process(_delta: float) -> void:
	var direcao = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	
	velocity = direcao * _movement_velocity
	move_and_slide()
	
	_animation_suffix = _character_suffix()
	_animate()


func _character_suffix() -> String:
	var _horizontal_input: float = Input.get_axis("move_left", "move_right")
	
	if _horizontal_input == -1:
		return "_left"
	
	if _horizontal_input == +1:
		return "_right"
	
	var _vertical_input: float = Input.get_axis("move_up", "move_down")
	
	if _vertical_input == -1:
		return "_up"
	
	if _vertical_input == +1:
		return "_down"
	return _animation_suffix


func _animate():
	if velocity:
		_player_animator.play("walking" + _animation_suffix)
		return
	_player_animator.play("idle" + _animation_suffix)
