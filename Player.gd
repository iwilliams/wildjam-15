extends RigidBody2D

export var ground_horizontal_speed = 4
export (float) var air_horizontal_speed = 2
export var stamina_recovery_rate = 10
export var stamina_recovery_period = 1000
export var jump_stamina_cost = 10
export var jump_force = 50

var stamina = 100
var on_ground = false
var last_jump = 0

onready var ground_check_l = get_node("GroundCheckL")
onready var ground_check_r = get_node("GroundCheckR")

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func jump():
  if stamina > 0:
    apply_central_impulse(Vector2(0, -jump_force))
    stamina -= jump_stamina_cost
    stamina = clamp(stamina, 0, 100)
    last_jump = OS.get_ticks_msec()
    $AnimationPlayer.play("Flying")
    $FlyingSFX.play()
#    $AnimatedSprite.frame = 0
#    $AnimatedSprite.play("flying")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  on_ground = \
    ground_check_l.get_collider() != null || \
    ground_check_r.get_collider() != null
  
  var horizontal_speed = ground_horizontal_speed
  if !on_ground:
    horizontal_speed = air_horizontal_speed
    
  if Input.is_action_pressed("move_right"):
    apply_central_impulse(Vector2(horizontal_speed, 0))
    pass
    
  if Input.is_action_pressed("move_left"):
    apply_central_impulse(Vector2(-horizontal_speed, 0))
    pass
    
  if OS.get_ticks_msec() - last_jump >= stamina_recovery_period && on_ground:
    stamina += stamina_recovery_rate * delta
    stamina = clamp(stamina, 0, 100)
    
  if linear_velocity.x != 0 && on_ground:
    $AnimationPlayer.play("Walking")
  elif on_ground:
    $AnimationPlayer.play("Idle")
      
  pass
  
func _input(event):
  if event.is_action_pressed("jump"):
    jump()
  pass





