extends Node2D

export (PackedScene) var game_scene

var game = null

# Called when the node enters the scene tree for the first time.
func _ready():
  start_game()
  pass # Replace with function body.

func start_game():
  game = game_scene.instance()
  game.connect("restart", self, "restart_game")
  add_child(game)
  
func restart_game():
  game.queue_free()
  remove_child(game)
  game = null
  call_deferred("start_game")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
