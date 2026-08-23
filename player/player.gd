extends CharacterBody2D

@export var _movement_velocity: float = 128.0
@export var _player_animator: AnimationPlayer
@export var _action_timer: Timer
@export var _attack_area: Area2D

var _can_attack: bool = true
var _animation_suffix: String = "_down"

func _physics_process(_delta: float) -> void:
	var direcao = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	
	velocity = direcao * _movement_velocity
	move_and_slide()
	
	_animation_suffix = _character_suffix()
	_attack()
	_animate()


func _character_suffix() -> String:
	var _horizontal_input: float = Input.get_axis("move_left", "move_right")
	
	if _horizontal_input == -1:
		_attack_area.position = Vector2(-15, 0)
		return "_left"
	
	if _horizontal_input == +1:
		_attack_area.position = Vector2(+16, 0)
		return "_right"
	
	var _vertical_input: float = Input.get_axis("move_up", "move_down")
	
	if _vertical_input == -1:
		_attack_area.position = Vector2(0, -12)
		return "_up"
	
	if _vertical_input == +1:
		_attack_area.position = Vector2(0, +12)
		return "_down"
	return _animation_suffix


func _attack() -> void:
	if Input.is_action_just_pressed("attack") and _can_attack:
		_player_animator.play("attack" + _animation_suffix)
		_action_timer.start(0.4)
		_can_attack = false
		set_physics_process(false)


func _animate() -> void:
	if _can_attack == false:
		return
	if velocity:
		_player_animator.play("walking" + _animation_suffix)
		return
	_player_animator.play("idle" + _animation_suffix)


func _on_action_timer_timeout() -> void:
	set_physics_process(true)
	_can_attack = true
