extends TextureProgressBar

@onready var player = get_tree().get_first_node_in_group('player')

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("damaged", _on_player_damaged)
	player.connect("healed", _on_player_healed)

func _on_player_damaged(amount):
	value=player.health
func _on_player_healed(amount):
	value=player.health

