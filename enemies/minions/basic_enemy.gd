class_name Enemy extends CharacterBody2D

signal died

@export var movement_speed = 350.0
@export var health = 20

@onready var player = get_tree().get_first_node_in_group('player')
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var hitbox = $HitBox
var is_alive = true
var is_player_hit = false

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	move_and_slide()
	
func take_damage():
	if health >= 0:
		health -= 20
	else:
		die()

func die():
	if (is_alive==true):
		player.heal(20)
		emit_signal("died")
		queue_free()



func _on_hit_box_body_entered(body):
	if body is Player:
		is_player_hit = true
		while(is_player_hit and player.is_alive):
			await get_tree().create_timer(.1).timeout
			var playerBody = body
			playerBody.take_damage(5)


func _on_hit_box_body_exited(body):
	if body is Player:
		is_player_hit = false
