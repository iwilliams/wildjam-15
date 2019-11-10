extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal room_entered
signal player_entered_death_area

onready var room_check = get_node("RoomCheck")

# Called when the node enters the scene tree for the first time.
func _ready():
  room_check.add_exception(get_node("Area2D"))
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _on_Area2D_body_entered(body):
  if body.is_in_group("Player"):
    var has_room_to_right = room_check.get_collider() != null
    emit_signal("room_entered", self, has_room_to_right)
  pass # Replace with function body.


func _on_DeathArea_body_entered(body):
  if body.is_in_group("Player"):
    emit_signal("player_entered_death_area")
  elif body.is_in_group("Platform"):
    print("Delete platform")
    body.queue_free()
  pass # Replace with function body.
