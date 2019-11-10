extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func _on_Platform_body_entered(body):
  print("Landed on")
  if mode != RigidBody2D.MODE_CHARACTER:
    get_node("AnimationPlayer").play("Shake")
    yield(get_tree().create_timer(1.0), "timeout")
    mode = RigidBody2D.MODE_CHARACTER
  pass # Replace with function body.
