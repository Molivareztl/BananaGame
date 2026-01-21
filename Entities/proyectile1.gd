extends Node3D
@onready var h_ray = $HurtRay
var speed = 25

func _process(delta):
	position += transform.basis * Vector3(0, 0, -speed) * delta
	if h_ray.is_colliding() and h_ray.get_collider().is_in_group("player"):
		h_ray.get_collider().hurt(1)
		queue_free()


func _on_timer_timeout():
	queue_free()
