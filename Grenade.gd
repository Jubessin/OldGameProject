extends RigidBody

const EXPLODE_TIMER = 0.48
var explosion_wait_timer = 0
var exp_dmg = 112
var shape
var grenadesprite 
var grenade_timer = 0
var GRENADE_TIME = 4

func _ready():
	shape = $CollisionShape
	grenadesprite = $Sprite3D
	$Particles.emitting = false
	$Particles2.emitting = false
	
func _process(delta):
	if grenade_timer < GRENADE_TIME:
        grenade_timer += delta
        return

	else:
		if explosion_wait_timer <= 0:
			$AudioStreamPlayer3D.play(0.0)
			$Particles.emitting = true
			$Particles2.emitting = true

			shape.disabled = true

			mode = RigidBody.MODE_STATIC

			var bodies = $GrenadeArea.get_overlapping_bodies()
			for body in bodies:
				if body.has_method("lose_health"):
					body.lose_health(exp_dmg)
	
		if explosion_wait_timer < EXPLODE_TIMER:
			explosion_wait_timer += delta
			if explosion_wait_timer >= EXPLODE_TIMER:
				
				queue_free()
			
