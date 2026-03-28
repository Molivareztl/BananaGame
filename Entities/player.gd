extends CharacterBody3D
@export var health = 100
var speed = 10
var jump = 8
var gravity = 20
var sensitivity = 100
@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera
@onready var standing = $NormalCollision
@onready var crounching = $CrouchCollision
@onready var c_ray = $CrouchRay
var can_shoot = true
var shake_strength = 0.0
var trail = load("res://Entities/player_bullet_trail.tscn")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	update_display()
	$HUD/ALotOfDamage/HudSprite.play("Idle")

func update_display():
	$HUD/Health/HealthDisplay.text = str(health)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x / sensitivity)
		camera.rotate_x(-event.relative.y / sensitivity)

func _physics_process(delta):
	if Input.is_action_pressed("crouch"):
		pivot.position.y = 1.0
		speed = 5
		gravity = 80
		standing.disabled = true
		crounching.disabled = false
	elif !c_ray.is_colliding():
		pivot.position.y = 1.5
		speed = 10
		gravity = 20
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
	move_and_slide()

func hurt(damage):
	health -= damage
	update_display()
	$HUD/ALotOfDamage/HudSprite.play("Hurt")
	$HUD/Health/HealthDisplay.hide()
	await $HUD/ALotOfDamage/HudSprite.animation_finished
	$HUD/ALotOfDamage/HudSprite.play("Idle")
	$HUD/Health/HealthDisplay.show()
	if health <= 0:
		health = 0
		$HUD/Death.show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func heal(amount):
	health += amount
	update_display()

func _on_continue_pressed():
	get_tree().paused = false
	$HUD/Pause.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_restart_pressed():
	get_tree().reload_current_scene()
