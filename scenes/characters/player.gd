extends Character
class_name Player


@onready var enemy_slots: Array = $EnemySlots.get_children()


func handle_input() -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if can_attack() and Input.is_action_just_pressed("attack"):
		state = State.ATTACK
		if is_last_hit_succesful:
			attack_combo_index = (attack_combo_index + 1) % anim_attacks.size()
			is_last_hit_succesful = false
		else:
			attack_combo_index = 0
	if can_jump() and Input.is_action_just_pressed("jump"):
		state = State.TAKEOFF
	if can_jumpkick() and Input.is_action_just_pressed("attack"):
		state = State.JUMPKICK
		
	
func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT
	

func reserve_slot(enemy: BasicEnemy) -> EnemySlot:
	var avaiable_slots := enemy_slots.filter(
		func(slot): return slot.is_free()
	)
	
	if avaiable_slots.size() == 0:
		return null
		
	avaiable_slots.sort_custom(
		func(a: EnemySlot, b: EnemySlot):
			var dist_a := (enemy.global_position - a.global_position).length()
			var dist_b := (enemy.global_position - b.global_position).length()
			return dist_a < dist_b
	)
	
	avaiable_slots[0].occupy(enemy)
	return avaiable_slots[0]


func free_slot(enemy: BasicEnemy) -> void:
	var target_slot = enemy_slots.filter(
		func(slot: EnemySlot): return slot.occupant == enemy
	)
	if target_slot.size() == 1:
		target_slot[0].free_up()
