extends EnemyBase

@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity.y += delta * _gravity
	flip_me()
	velocity.x = speed if animated_sprite_2d.flip_h else -speed
	
	move_and_slide()

func flip_me() -> void:
	if is_on_wall() or !ray_cast_2d.is_colliding():
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		ray_cast_2d.position.x = -ray_cast_2d.position.x
