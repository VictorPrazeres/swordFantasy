extends Area2D

@export var required_tool: String
@export var _health: int = 10


func losing_health(_damage: int) -> void:
	_health -= _damage
	if _health > 0:
		$AnimationPlayer.play("losing_health")
		return
		
	queue_free()
