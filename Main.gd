extends Node2D

export (PackedScene) var game_scene

var game = null
var is_restarting = false

var save_file_path = "user://save.json"
var save_data = { 
  "high_score": 0
}

var high_score = 0
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  load_save_data()
  start_game()
  pass # Replace with function body.

func load_save_data():
  if !OS.is_userfs_persistent():
    return
  var save_file = File.new()
  if not save_file.file_exists(save_file_path):
    return
    
  save_file.open(save_file_path, File.READ)
  var json_string = parse_json(save_file.get_as_text())
  save_file.close()
  print(json_string)
  save_data["high_score"] = json_string["high_score"]
  high_score = save_data["high_score"]
  print(high_score)
  update_high_score_label()
  pass
  
func update_high_score_label():
  $HUD/Container/HighScore.text = "HIGH SCORE:" + str(high_score) + "M"

func start_game():
  is_restarting = false
  game = game_scene.instance()
  on_update_score(0)
  game.connect("restart", self, "restart_game")
  game.connect("update_score", self, "on_update_score")
  add_child(game)
  
func on_update_score(current_score):
  if is_restarting:
     return
  if current_score > high_score:
    high_score = current_score
    update_high_score_label()
  score = current_score
  $HUD/Container/Score.text = "SCORE:" + str(score) + "M"
  
func restart_game():
  if !is_restarting:
    is_restarting = true
    save_game()
    yield(get_tree().create_timer(1.5), "timeout")
    game.queue_free()
    game = null
    call_deferred("start_game")
    
func save_game():
  if !OS.is_userfs_persistent():
    return
  var save_file = File.new()
  save_file.open(save_file_path, File.WRITE)
  save_file.store_string(to_json({ "high_score": high_score }))
  save_file.close()
