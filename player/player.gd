class_name Player extends CharacterBody2D

signal died

@export var fire_rate := 0.15
@export var SPEED := 450.0
@export var health := 100

@onready var rightArm = $RightArm
@onready var leftArm = $LeftArm
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D


var punch_scene = preload("res://player/basic_punch.tscn")

var is_alive = true
var shoot_cd = false
var punch_sequence = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.

func _physics_process(_delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if is_alive:
		var dirX = Input.get_axis("move_left", "move_right")
		
		if dirX:
			velocity.x = dirX * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		var dirY = Input.get_axis("move_forward", "move_backward")
		if dirY:
			velocity.y = dirY * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)

		move_and_slide()

func _process(_delta):
	if !is_alive: return
	
	if Input.is_action_pressed("punch"):
		if !shoot_cd:
			shoot_cd = true
			throwPunch()
			await get_tree().create_timer(fire_rate).timeout
			shoot_cd = false
	look_at(get_global_mouse_position())

func throwPunch():
	var p = punch_scene.instantiate()
	get_tree().root.get_child(0).add_child(p)
	if(punch_sequence == 0):
		p.global_position = rightArm.global_position
		punch_sequence = 1
	else:
		p.global_position = leftArm.global_position
		punch_sequence = 0
	
	p.rotation = rotation

func take_damage():
	if health > 0:
		health -= 20
		print("taking damage")
		print(health)
	else:
		die()

func heal(healValue):
	if health > 0 and health < 100:
		health += healValue
		print("healing")
		print(health)

func die():
	if (is_alive==true):
		is_alive = false
		sprite.visible = false
		cshape.set_deferred("disabled", true)
		emit_signal("died")

