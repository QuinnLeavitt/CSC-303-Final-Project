extends Node2D
@onready var game_over_screen = $game_over_screen
@onready var hud =$hud
var score := 0:
	set(value):
		score = value
		hud.score = score

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_player_died():
	await get_tree().create_timer(2).timeout
	game_over_screen.visible = true




func _on_basic_enemy_died():
	score += 20
