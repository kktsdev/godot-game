extends CharacterBody2D

const BULLET_SCENE: PackedScene = preload("res://src/scenes/bullet.tscn")

const SPEED: float = 600.
const ACCELERATION: float = 1200.
const FRICTION: float = 400.
const ROTATION_SPEED: float = 10.

func _ready() -> void:
  self.motion_mode = MOTION_MODE_FLOATING

func _process(delta: float) -> void:
  move_and_rotate(delta)

  if Input.is_action_just_pressed("player_attack"):
    shoot()

func move_and_rotate(delta: float) -> void:
  var input = get_input()
  if input != Vector2.ZERO:
    velocity = velocity.move_toward(input * SPEED, ACCELERATION * delta)
  else:
    velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
  move_and_slide()

  var mouse_pos = get_global_mouse_position()
  var target_rotation = (mouse_pos - self.global_position).angle()
  self.rotation = lerp_angle(self.rotation, target_rotation, ROTATION_SPEED * delta)

func shoot():
  var bullet = BULLET_SCENE.instantiate()
  get_parent().add_child(bullet)
  bullet.global_position = self.global_position
  var direction = Vector2(cos(self.rotation), sin(self.rotation))
  bullet.set_velocity(direction, velocity)

func get_input() -> Vector2:
  var input = Vector2.ZERO
  if Input.is_action_pressed("player_move_right"):
    input.x += 1
  if Input.is_action_pressed("player_move_left"):
    input.x -= 1
  if Input.is_action_pressed("player_move_down"):
    input.y += 1
  if Input.is_action_pressed("player_move_up"):
    input.y -= 1
  return input.normalized()
