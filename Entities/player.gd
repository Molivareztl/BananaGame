extends CharacterBody3D
var health = 5
var speed = 10
var jump = 8
var gravity = 20
var sensitivity = 100
@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D
@onready var standing = $NormalCollision
@onready var crounching = $CrouchCollision
@onready var c_ray = $CrouchRay
@onready var s_ray = $Pivot/Camera3D/ShootRay
@onready var pos1 = $Pivot/Camera3D/BarrelBegin
@onready var pos2 = $Pivot/Camera3D/BarrelEnd
var can_shoot = true
var trail = load("res://Entities/player_bullet_trail.tscn")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x / sensitivity)
		camera.rotate_x(-event.relative.y / sensitivity)

func _physics_process(delta):
	if Input.is_action_pressed("crouch"):
		pivot.position.y = 1.0
		speed = 5
		standing.disabled = true
		crounching.disabled = false
	elif !c_ray.is_colliding():
		pivot.position.y = 1.5
		speed = 10
		standing.disabled = false
		crounching.disabled = true
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		$HUD/Pause.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var input = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.z = 0
		velocity.x = 0
	if Input.is_action_pressed("shoot") and can_shoot == true:
		can_shoot = false
		shoot()
	move_and_slide()

func hurt(damage):
	health -= damage
	$HUD/ALotOfDamage.show()
	await get_tree().create_timer(0.2).timeout
	$HUD/ALotOfDamage.hide()
	if health <= 0:
		health = 0
		$HUD/Death.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func shoot():
	var instance
	instance = trail.instantiate()
	if s_ray.is_colliding() and s_ray.get_collider().is_in_group("enemy"):
		s_ray.get_collider().hurt(1)
		instance.draw(pos1.global_position, s_ray.get_collision_point())
	else:
		instance.draw(pos1.global_position, pos2.global_position)
	get_parent().add_child(instance)
	if can_shoot == false:
		await get_tree().create_timer(0.5).timeout 
		can_shoot = true



