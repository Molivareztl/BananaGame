extends CharacterBody3D
var speed = 5.0
var health = 5
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var face = $Direction
var gravity = 20
@onready var sfx = $Sfx
@onready var h_ray = $HurtRay
var can_hurt = true

func _physics_process(delta):
	face.look_at(player.global_position)
	rotate_y(face.rotation.y * 0.05)
	if not is_on_floor():
		velocity.y -= gravity * delta
	var dir = (player.global_position - global_position).normalized()
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	if can_hurt == true:
		$Model/AnimationPlayer.play("run")
	move_and_slide()
	attack()

func attack():
	if h_ray.is_colliding() and h_ray.get_collider().is_in_group("player") and can_hurt == true:
		can_hurt = false
		h_ray.get_collider().hurt(1)
		speed = 0
		$Model/AnimationPlayer.play("idle")
		await get_tree().create_timer(1).timeout 
		can_hurt = true
		speed = 5.0

func hurt(damage):
	sfx.play()
	health = health - damage
	if health <= 0:
		can_hurt = false
		$Model/AnimationPlayer.play("death")
		h_ray.enabled = false
		speed = 0
		await $Model/AnimationPlayer.animation_finished
		queue_free()

func _exit_tree(): # When someone calls queue_free() here
	$Model/Skeleton/banana_man.set("surface_material_override/0", null)
