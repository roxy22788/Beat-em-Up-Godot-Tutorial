extends Node2D
class_name EnemySlot


var occupant: BasicEnemy = null


func is_free() -> bool:
	return occupant == null
	
	
func free_up() -> void:
	occupant = null
	
	
func occupy(enemy: BasicEnemy) -> void:
	occupant = enemy
