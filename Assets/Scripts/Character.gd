extends CharacterBody2D


const SPEED = 130
var actualSpeed = 0

func _physics_process(delta):
	move()
	animate()

func move():
	var direction = Vector2.ZERO
	if $Inputs.up:
		direction+=Vector2(0,-0.75)
	if $Inputs.down:
		direction+=Vector2(0,0.75)
	if $Inputs.left:
		direction+=Vector2(-1,0)
	if $Inputs.right:
		direction+=Vector2(1,0)
	if $Inputs.modifier:
		actualSpeed = SPEED/2
	else:
		actualSpeed = SPEED
	#direction = direction.normalized()
	velocity = direction * actualSpeed
	
	move_and_slide()
	
func animate():
	if velocity.x>0:
		$Sprite2D.flip_h = false
	elif velocity.x<0:
		$Sprite2D.flip_h = true
	if !$Inputs.modifier and velocity.length() > .1:
		$Sprite2D/AnimationPlayer.play("run")
		$Sprite2D/AnimationPlayer.speed_scale=.95
	elif $Inputs.modifier and velocity.length() > .1:
			$Sprite2D/AnimationPlayer.play("walk")
			$Sprite2D/AnimationPlayer.speed_scale=0.6
	else:
		$Sprite2D/AnimationPlayer.play("idle")
