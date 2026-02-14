extends CharacterBody3D

@onready var area= $Area
var gravity = 20
@onready var face = $Direction
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var player_dial = get_tree().get_first_node_in_group("dialogue")
var talk_mode = false
@export var dialogue : String

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	if talk_mode == true:
		face.look_at(player.global_position)
		rotate_y(face.rotation.y * 0.05)
	else :
		rotation = Vector3.ZERO
		rotate_y(face.rotation.y * 0.05)

func _on_area_body_entered(body):
	if body.is_in_group("player"):
		talk_mode = true
		player_dial.talk(dialogue)

func _on_area_body_exited(body):
		if body.is_in_group("player"):
			talk_mode = false
			player_dial.close()
