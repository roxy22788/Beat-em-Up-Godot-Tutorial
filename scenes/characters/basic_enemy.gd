extends Character
class_name BasicEnemy


@export var player : Player


func handle_input() -> void:
	if player == null or not can_move():
		return
		
	var direction := (player.position - position).normalized()
	velocity = direction * speed
	
