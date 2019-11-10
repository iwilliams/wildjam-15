extends Node2D

signal room_entered
signal player_entered_death_area

export (PackedScene) var platform_scene

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

func spawn_platforms():
  randomize()
  
  # Determine how many platforms to spawn
  var possible_platforms = [2, 3]
  possible_platforms.shuffle()
  var num_platforms = possible_platforms.pop_front()

  # Get the possible spawn columns and randomize them
  var spawns = [spawn_1, spawn_2, spawn_3, spawn_4]
  spawns.shuffle()
  
  for i in num_platforms:
    var spawn = spawns.pop_front()
    var platform = platform_scene.instance()
    platform.position = Vector2(
      spawn.position.x,
      rand_range(
        spawn.position.y + spawn.get_node("Top").position.y,
        spawn.position.y + spawn.get_node("Bottom").position.y
      )
    )
    add_child(platform)

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
