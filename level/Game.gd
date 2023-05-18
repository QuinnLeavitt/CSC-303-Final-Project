extends Node2D
@onready var game_over_screen = $game_over_screen
@onready var hud = $hud
@onready var enemy_spawn_area = $player/EnemySpawnArea
@onready var enemies = $Enemies
@onready var only_once : bool = true

signal spawn_enemies
var enemy_number = 5
var enemy_scene = preload("res://enemies/minions/basic_enemy.tscn")
var score := 0:
	set(value):
		score = value
		hud.score = score

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	self.connect("spawn_enemies", _on_spawn_enemies)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(enemies.get_child_count() <= 3):
		emit_signal("spawn_enemies")


func _on_player_died():
	await get_tree().create_timer(2).timeout
	game_over_screen.visible = true

func _on_basic_enemy_died():
	score += 20
	
func spawn_enemy(pos):
	var e = enemy_scene.instantiate()
	e.global_position = pos
	e.connect("died", _on_basic_enemy_died)
	enemies.call_deferred("add_child", e)
	return e

func place_enemies(enemy_count):
	var screen_size = get_viewport_rect().size
	for i in enemy_count:
		var enemy_placed = false
		while !enemy_placed:
			var pos = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
			var query_params = PhysicsPointQueryParameters2D.new()
			query_params.set_position(pos)
			query_params.set_collide_with_bodies(true)
			query_params.set_collide_with_areas(true)
			var result = get_world_2d().get_direct_space_state().intersect_point(query_params, 32)
			if(result.is_empty()):
				spawn_enemy(pos)
				await get_tree().create_timer(5)
				enemy_placed = true
				break
	enemy_number += 1

func _on_spawn_enemies():
	place_enemies(enemy_number)
	await get_tree().create_timer(1).timeout
