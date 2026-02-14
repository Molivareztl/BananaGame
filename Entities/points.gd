extends Node3D

@onready var area = $Area
@onready var sprite = $Sprite
var amount = 1

func _ready():
	sprite.play("default")

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.heal(amount)
		queue_free()
