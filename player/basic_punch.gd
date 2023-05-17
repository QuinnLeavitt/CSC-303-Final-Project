extends Area2D

@onready var lifetime = $Lifetime

func _ready():
	lifetime.start()

func _on_lifetime_timeout():
	queue_free()
