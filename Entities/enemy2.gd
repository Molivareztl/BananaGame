extends CharacterBody3D
var health = 5
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var face = $Direction
@onready var pivot = $Pivot
@onready var h_ray = $Pivot/HurtRay
@onready var sfx = $Sfx
@onready var proyectile = preload("res://Entities/proyectile1.tscn")
var gravity = 20
var can_hurt = true

func _physics_process(delta):
	face.look_at(player.global_position)
	pivot.rotation.y = face.rotation.y
	pivot.rotation.x = clamp((face.rotation.x + 0.2), -180, 360)
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	attack()

func attack():
	if h_ray.is_colliding() and h_ray.get_collider().is_in_group("player") and can_hurt == true:
		can_hurt = false
		var instance = proyectile.instantiate()
		get_parent().add_child(instance)
		instance.global_transform = h_ray.global_transform
		await get_tree().create_timer(1).timeout 
		can_hurt = true

func hurt(damage):
	sfx.play()
	health = health - damage
	if health <= 0:
		h_ray.enabled = false
		await get_tree().create_timer(1).timeout 
		queue_free()
