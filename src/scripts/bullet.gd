extends Area2D

const BULLET_SPEED: float = 1000.
const BULLET_FRICTION: float = 400.
const DAMAGE: float = 50.
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
  set_process(true)

func _process(delta: float) -> void:
  velocity = velocity.move_toward(Vector2.ZERO, BULLET_FRICTION * delta)
  position += velocity * delta
  if velocity == Vector2.ZERO:
    queue_free()

func _on_area_entered(area: Area2D) -> void:
  if area is HitboxComponent:
    var hitbox: HitboxComponent = area
    hitbox.damage(DAMAGE)
    queue_free()

func set_velocity(direction: Vector2, base_velocity: Vector2) -> void:
  velocity = (direction.normalized() * BULLET_SPEED) + base_velocity
