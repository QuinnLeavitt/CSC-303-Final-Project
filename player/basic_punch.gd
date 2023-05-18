extends Area2D

@onready var lifetime = $Lifetime

func _ready():
	lifetime.start()

func _on_lifetime_timeout():
	queue_free()

func _on_body_entered(body):
	if body is Enemy:
		var enemy = body
		enemy.take_damage()
