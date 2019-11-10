extends RigidBody2D

export var should_fall = true

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func _on_Platform_body_entered(body):
  print("Landed on")
  if should_fall && mode != RigidBody2D.MODE_CHARACTER:
    get_node("AnimationPlayer").play("Shake")
    yield(get_tree().create_timer(1.0), "timeout")
    mode = RigidBody2D.MODE_CHARACTER
  pass # Replace with function body.
