extends Node2D

export (PackedScene) var game_scene

var game = null
var is_restarting = false

# Called when the node enters the scene tree for the first time.
func _ready():
  start_game()
  pass # Replace with function body.

func start_game():
  is_restarting = false
  game = game_scene.instance()
  game.connect("restart", self, "restart_game")
  add_child(game)
  
func restart_game():
  if !is_restarting:
    is_restarting = true
    yield(get_tree().create_timer(1.5), "timeout")
    game.queue_free()
    game = null
    call_deferred("start_game")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
