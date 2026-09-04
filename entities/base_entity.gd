extends CharacterBody2D

@export var _wander_time: Timer
@export var _normal_move_speed: float = 32.0
@export var _running_move_speed: float = 64.0

var direction: Vector2

func _ready() -> void:
	direction = get_random_direction()
	_wander_time.start(5.0)


func _physics_process(_delta: float) -> void:
	velocity = _normal_move_speed * direction
	move_and_slide()
	
	_bounce()


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
