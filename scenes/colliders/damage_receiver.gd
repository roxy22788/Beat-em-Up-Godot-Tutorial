extends Area2D
class_name DamageReceiver

enum HitType {NORMAL, KNOCKDOWN, POWER}

signal damage_received(damage: int, direction: Vector2, hit_type: HitType)
