extends CharacterBody2D
class_name Character

const GRAVITY := 600.0

@export var damage: int
@export var jump_intensity: float 
@export var knockback_intensity: float
@export var max_health: int
@export var speed: float

@onready var animation_player = $AnimationPlayer
@onready var character_sprite = $CharacterSprite
@onready var damage_emitter = $DamageEmitter
@onready var damage_receiver = $DamageReceiver

enum State {IDLE, WALK, ATTACK, TAKEOFF, JUMP, LAND, JUMPKICK, HURT}

var anim_map := {
	State.IDLE: "idle",
	State.WALK: "walk",
	State.ATTACK: "punch",
	State.TAKEOFF: "takeoff",
	State.JUMP: "jump",
	State.LAND: "land",
	State.JUMPKICK: "jumpkick",
	State.HURT: "hurt"
}

var current_health := 0
var height: float = 0.0
var height_speed: float = 0.0
var state = State.IDLE


func _ready() -> void:
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	damage_receiver.damage_receiver.connect(on_receive_damage.bind())
	current_health = max_health


func _process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animations()
	handle_air_time(delta)
	flip_sprites()
	character_sprite.position = Vector2.UP * height
	move_and_slide()


func handle_movement() -> void:
	if not can_move():
		return
		
	if velocity.length() == 0:
		state = State.IDLE
	else:
		state = State.WALK


func handle_input() -> void:
	pass
	
	
func handle_animations() -> void:
	var anim = anim_map.get(state)
	if animation_player.has_animation(anim):
		animation_player.play(anim)
		
		
func handle_air_time(delta: float) -> void:
	if state == State.JUMP or state == State.JUMPKICK:
		height += height_speed * delta
		if height < 0:
			height = 0
			state = State.LAND
		else:
			height_speed -= GRAVITY * delta


func flip_sprites() -> void:
	if velocity.x > 0:
		character_sprite.flip_h = false
		damage_emitter.scale.x = 1
	elif velocity.x < 0:
		character_sprite.flip_h = true
		damage_emitter.scale.x = -1
		
		
func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK
	
	
func can_jump() -> bool:
	return state == State.IDLE or state == State.WALK
	

func can_jumpkick() -> bool:
	return state == State.JUMP
	

func can_move() -> bool:
	return (state == State.IDLE or state == State.WALK)
	
	
func _on_action_complete() -> void:
	state = State.IDLE
	damage_emitter.monitoring = false
	
	
func on_takeoff_complete() -> void:
	state = State.JUMP
	height_speed = jump_intensity
	
	
func on_land_complet() -> void:
	state = State.IDLE
	
	
func on_receive_damage(damage: int, direction: Vector2) -> void:
	current_health = clamp(current_health - damage, 0, max_health)
	if current_health <= 0:
		queue_free()
	else:
		state = State.HURT
		velocity = direction * knockback_intensity
	

func on_emit_damage(damage_receiver: DamageReceiver) -> void:
	var direction = Vector2.LEFT if damage_receiver.global_position.x < global_position.x else Vector2.RIGHT
	damage_receiver.damage_receiver.emit(damage, direction)
	print(damage_receiver)
