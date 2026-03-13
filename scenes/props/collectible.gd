extends Area2D
class_name Collectible

const GRAVITY := 600.0

enum State {FALL, GROUNDED, FLY}
enum Type {KNIFE, GUN, FOOD}

@export var knockdown_intensity: float
@export var speed: float
@export var type: Type

var anim_map := {
	State.FALL: "fall",
	State.GROUNDED: "grounded",
	State.FLY: "fly"
}
var height := 0.0
var height_speed := 0.0
var state = State.FALL


@onready var animation_player = $AnimationPlayer
@onready var collectible_sprite = $CollectibleSprite


func _ready() -> void:
	height_speed = knockdown_intensity


func _process(delta: float) -> void:
	handle_fall(delta)
	handle_animations()
	collectible_sprite.position = Vector2.UP * height
	
	
func handle_animations() -> void:
	animation_player.play(anim_map[state])
	
	
func handle_fall(delta: float) -> void:
	if state == State.FALL:
		height += height_speed * delta
		if height < 0:
			height = 0
			state = State.GROUNDED
		else:
			height_speed -= GRAVITY * delta
