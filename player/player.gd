class_name Player extends CharacterBody2D

@export var fire_rate := 0.15
@export var SPEED := 400.0

@onready var rightArm = $RightArm
@onready var leftArm = $LeftArm


var punch_scene = preload("res://player/basic_punch.tscn")

var is_alive = true
var shoot_cd = false


# Get the gravity from the project settings to be synced with RigidBody nodes.

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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

func _process(delta):
	if !is_alive: return
	
	if Input.is_action_pressed("punch"):
		if !shoot_cd:
			shoot_cd = true
			throwPunch()
			await get_tree().create_timer(fire_rate).timeout
			shoot_cd = false
	look_at(get_global_mouse_position())
func throwPunch():
	print("punch!")
	var p = punch_scene.instantiate()
	p.global_position = rightArm.global_position
	p.rotation = rotation
