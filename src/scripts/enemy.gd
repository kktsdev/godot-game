extends CharacterBody2D

enum State { IDLE, ATTACKING }

const SPEED: float = 400.
const ROTATION_SPEED: float = 3.
const DIRECTION_CHANGE_INTERVAL_MIN: float = 2.
const DIRECTION_CHANGE_INTERVAL_MAX: float = 8.
const MIN_DISTANCE_TO_PLAYER: float = 200.
const MAX_ATTACKING_DISTANCE: float = 400.
const MAX_VISION_DISTANCE: float = 800.
const VELOCITY_INTERPOLATION: float = 5.

var state: State = State.IDLE
var target_direction: float
var target_velocity: Vector2
var player_node: Node
var direction_change_timer: float = 0.

func _ready() -> void:
  player_node = get_parent().get_node("Player")
  set_random_direction()
  set_process(true)

func _process(delta: float) -> void:
  direction_change_timer -= delta
  update_state()
  match state:
    State.IDLE:
      target_velocity = Vector2(SPEED, 0).rotated(rotation)
      if direction_change_timer <= 0:
        set_random_direction()
    State.ATTACKING:
      move_towards_player()
  rotation = lerp_angle(rotation, target_direction, ROTATION_SPEED * delta)
  velocity = lerp(velocity, target_velocity, VELOCITY_INTERPOLATION * delta)
  move_and_slide()

func update_state() -> void:
  var distance_to_player = get_distance_to_player()
  if distance_to_player < MAX_ATTACKING_DISTANCE:
    state = State.ATTACKING
  if distance_to_player > MAX_VISION_DISTANCE:
    state = State.IDLE

func move_towards_player() -> void:
  if player_node == null:
    return
  target_direction = (player_node.global_position - global_position).angle()
  if get_distance_to_player() < MIN_DISTANCE_TO_PLAYER:
    target_velocity = Vector2.ZERO
  else:
    target_velocity = Vector2(SPEED, 0).rotated(rotation)

func set_random_direction() -> void:
  target_direction = randf_range(0, 2 * PI)
  direction_change_timer = randf_range(DIRECTION_CHANGE_INTERVAL_MIN, DIRECTION_CHANGE_INTERVAL_MAX)

func get_distance_to_player() -> float:
  if player_node == null:
    return 0
  return global_position.distance_to(player_node.global_position)
