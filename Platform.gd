extends RigidBody2D

export var should_fall = true
var is_falling = false

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func _start_falling(animation):
  mode = RigidBody2D.MODE_CHARACTER
  pass

func _on_Platform_body_entered(body):
  print("Landed on")
  if should_fall && !is_falling:
    is_falling = true
    get_node("AnimationPlayer").play("Shake")
    get_node("AnimationPlayer").connect(
      "animation_finished",
      self,
      "_start_falling"
    )
  pass # Replace with function body.
