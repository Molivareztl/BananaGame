extends CharacterBody3D
var health = 5
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var face = $Direction
@onready var collision = $Collision
@onready var pivot = $Pivot
@onready var h_ray = $Pivot/HurtRay
@onready var sfx = $Sfx
var gravity = 20
var can_hurt = true

func _physics_process(delta):
	face.look_at(player.global_position)
	pivot.rotation.y = lerp_angle(pivot.rotation.y, face.rotation.y, 0.05)
	pivot.rotation.x = lerp_angle(pivot.rotation.x, clamp(face.rotation.x, 0, 360), 0.05) 
	pivot.rotation.y = pivot.rotation.y
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	attack()
	move_and_slide()

func attack():
	return

func hurt(damage):
	sfx.play()
	health = health - damage
	if health <= 0:
		h_ray.enabled = false
		await get_tree().create_timer(1).timeout 
		queue_free()
