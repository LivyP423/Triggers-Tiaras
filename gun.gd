extends CharacterBody2D

@onready var shoot_raycast = $RayCast2D
@onready var Muzzle = $RayCast2D/Muzzle
@onready var sprite = $Sprite2D
@onready var raycast_base_x: float = shoot_raycast.position.x
@onready var muzzle_base_x: float = Muzzle.position.x
@onready var audio = $AudioStreamPlayer2D

const RAY_DISTANCE = 1400
const Bullet = preload("res://bullet.tscn")

func _physics_process(delta: float) -> void:
	if not gamemaster1.alive:
		return
		
	if Input.is_action_just_pressed("shoot"):
		if shoot_raycast.is_colliding():
			var collider = shoot_raycast.get_collider()
			if collider.has_method("take_enemy_damage"):
				collider.take_enemy_damage(1)
		shoot()
		
	if Input.is_action_pressed("left"):
		sprite.flip_h = true
		shoot_raycast.target_position.x = -RAY_DISTANCE
		shoot_raycast.position.x = -raycast_base_x
		Muzzle.position.x = -muzzle_base_x
	elif Input.is_action_pressed("right"):
		sprite.flip_h = false
		shoot_raycast.target_position.x = RAY_DISTANCE
		shoot_raycast.position.x = raycast_base_x
		Muzzle.position.x = muzzle_base_x
			
func shoot() -> void:
	audio.play()
	var b = Bullet.instantiate()
	var spawn_node = owner if owner else get_parent()
	spawn_node.add_child(b)
	
	b.global_position = Muzzle.global_position
	
	if sprite.flip_h:
		b.global_rotation = PI
	else:
		b.global_rotation = 0.0
