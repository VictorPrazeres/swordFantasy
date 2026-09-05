extends CharacterBody2D

@export var _wander_time: Timer
@export var _running_time: Timer
@export var _animator: AnimationPlayer
@export var _texture: Sprite2D
@export var _normal_move_speed: float = 32.0
@export var _running_move_speed: float = 64.0
@export var _life: int = 10
@export var _is_hostile: bool = false

var player: CharacterBody2D
var direction: Vector2
var is_running: bool = false

func _ready() -> void:
	direction = get_random_direction()
	_wander_time.start(5.0)


func _physics_process(_delta: float) -> void:
	velocity = _normal_move_speed * direction
	if is_running:
		velocity = _running_move_speed * direction
	
	if is_instance_valid(player):
		direction = global_position.direction_to(player.global_position)
		velocity = _normal_move_speed * direction
	
	move_and_slide()
	
	_bounce()
	_animate()

func _animate() -> void:
	if velocity.x > 0:
		_texture.flip_h = true
		if _is_hostile:
			_texture.flip_h = false
	if velocity.x < 0:
		_texture.flip_h = false
		if _is_hostile:
			_texture.flip_h = true
	if velocity != Vector2(0, 0):
		_animator.play("walking")
		return
	_animator.play("idle")


func _bounce() -> void:
	if get_slide_collision_count() > 0:
		direction = velocity.bounce(get_slide_collision(0).get_normal()).normalized()


func get_random_direction() -> Vector2:
	return Vector2(
		[-1, 0, +1].pick_random(),
		[-1, 0, +1].pick_random()
	).normalized()


func _on_wander_time_timeout() -> void:
	_wander_time.start(5.0)
	if direction != Vector2(0, 0):
		direction = Vector2(0, 0)
		return
	
	if direction == Vector2(0, 0):
		direction = get_random_direction()


func losing_health(_damage_received: int) -> void:
	_life -= _damage_received
	if _life > 0:
		if _is_hostile:
			return
		direction = get_random_direction()
		_running_time.start(5.0)
		is_running = true
		_wander_time.stop()
		return
	_kill()


func _kill() -> void:
	queue_free()


func _on_running_time_timeout() -> void:
	_wander_time.start(5.0)
	is_running = false


func _on_detection_area_body_entered(_body: Node2D) -> void:
	if _is_hostile == false:
		return
	if _body.is_in_group("player"):
		_wander_time.stop()
		player = _body

func _on_detection_area_body_exited(_body: Node2D) -> void:
	if _is_hostile == false:
		return
	if _body.is_in_group("player"):
		_wander_time.start(5.0)
		player = null
