extends Node
class_name HealthComponent

@export var max_health: float = 100.
var health: float

func _ready() -> void:
  health = max_health

func damage(amount: float) -> void:
  health -= amount
  if health <= 0.:
    get_parent().queue_free()
