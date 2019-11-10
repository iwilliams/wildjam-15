extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var room_scene

onready var player = get_node("Player")
onready var stamina_bar = get_node("Player/StaminaBar")
onready var score_label = get_node("HUD/Container/Score")

# Called when the node enters the scene tree for the first time.
func _ready():
  connect_room_signals(get_node("Rooms/Room"))
  pass
  
func _process(delta):
  stamina_bar.value = player.stamina
  score_label.text = "DISTANCE: " + str(floor(player.position.x/100)) + "M"
  pass

func create_room(position):
  print("Creating room...")
  var room = room_scene.instance()
  room.position = position
  get_node("Rooms").add_child(room)
  connect_room_signals(room)
  pass

func connect_room_signals(room):
  room.connect("room_entered", self, "_on_room_entered")
  room.connect("player_entered_death_area", self, "_on_player_entered_death_area")
  
func _on_room_entered(room, has_room_to_right):
  print("Room entered: " + str(room))
  if !has_room_to_right:
    call_deferred("create_room", room.position + Vector2(1024, 0))
  pass # Replace with function body.
  
func _on_player_entered_death_area():
  get_tree().reload_current_scene()
  pass
