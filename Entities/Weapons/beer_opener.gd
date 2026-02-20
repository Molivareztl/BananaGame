extends Node3D

@onready var s_ray = $ShootRay
@onready var pos1 = $ShootRay/BarrelBegin
@onready var pos2 = $ShootRay/BarrelEnd
@onready var display = $WeaponAnimation
@export var stomach = 1000
@export var hunger = 20
var can_shoot = true
var trail = load("res://Entities/player_bullet_trail.tscn")
func _input(_event):
	if Input.is_action_just_pressed("shoot") and can_shoot == true:
		can_shoot = false
		shoot()
		display.play("revolver_shoot")
		stomach -= hunger
	if Input.is_action_just_released("shoot"):
		can_shoot = true
	if Input.is_action_just_pressed("check"):
		display.play("revolver_check_in")
		await display.animation_finished
		$Stomach/ColorRect/Label.text = str(stomach)
		$Stomach.show()
	if Input.is_action_just_released("check"):
		display.play("revolver_check_out")
		$Stomach.hide()

func shoot():
	if s_ray.is_colliding() and s_ray.get_collider().is_in_group("enemy"):
		s_ray.get_collider().hurt(1)
