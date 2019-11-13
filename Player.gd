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
var queue_jump = false
var should_die = false
var is_dieing = false

onready var ground_check_l = get_node("GroundCheckL")
onready var ground_check_r = get_node("GroundCheckR")

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func die():
  if !should_die && !is_dieing:
    mode = RigidBody2D.MODE_RIGID
    set_collision_layer_bit(1, false)
    should_die = true

func jump():
  if stamina > 0:
    apply_central_impulse(Vector2(0, -jump_force))
    stamina -= jump_stamina_cost
    stamina = clamp(stamina, 0, 100)
    last_jump = OS.get_ticks_msec()
    $AnimationPlayer.seek(0)
    $AnimationPlayer.play("Flying")
    var sfx = $FlyingSFX.duplicate()
    sfx.autoplay = true
    add_child(sfx)
    sfx.connect("finished", sfx, "queue_free")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
  if should_die:
    should_die = false
    is_dieing = true
    apply_impulse(Vector2(-200, 0), Vector2(-220, -220))
    return  
    
  if is_dieing:
    return
    
  if queue_jump:
    jump()
    queue_jump = false
    return
    
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
    queue_jump = true
  pass





