extends Node2D

signal room_entered
signal player_entered_death_area

export (PackedScene) var platform_scene
export (PackedScene) var saw_scene

onready var room_check = get_node("RoomCheck")
onready var spawn_1 = get_node("Spawn1")
onready var spawn_2 = get_node("Spawn2")
onready var spawn_3 = get_node("Spawn3")
onready var spawn_4 = get_node("Spawn4")

# Called when the node enters the scene tree for the first time.
func _ready():
  room_check.add_exception(get_node("Area2D"))
  spawn_platforms()
  pass # Replace with function body.

func get_spawn_position(spawn):
  return Vector2(
    spawn.position.x,
    rand_range(
      spawn.position.y + spawn.get_node("Top").position.y,
      spawn.position.y + spawn.get_node("Bottom").position.y
    )
  )
  
func spawn_platform(spawn):
  var platform = platform_scene.instance()
  platform.position = get_spawn_position(spawn)
  add_child(platform)
  pass

func spawn_saw(spawn):
  var saw = saw_scene.instance()
  saw.position = get_spawn_position(spawn)
#  saw.connect("body_entered", self, "_on_DeathArea_body_entered")
  saw.connect("body_entered", self, "_on_saw_entered")
  add_child(saw)
  pass

func spawn_platforms():
  randomize()
  spawn_platform(spawn_1)
  if rand_range(0, 1) > .75:
    spawn_saw(spawn_2)
  else:
    spawn_platform(spawn_2)
  spawn_platform(spawn_3)  

func _on_saw_entered(body):
  if body.is_in_group("Player"):
    body.call_deferred("die")

func _on_Area2D_body_entered(body):
  if body.is_in_group("Player"):
    var has_room_to_right = room_check.get_collider() != null
    emit_signal("room_entered", self, has_room_to_right)
  pass # Replace with function body.

func _on_DeathArea_body_entered(body):
  print("HIT")
  if body.is_in_group("Player"):
    emit_signal("player_entered_death_area")
  elif body.is_in_group("Platform"):
    print("Delete platform")
    body.queue_free()
  pass # Replace with function body.
