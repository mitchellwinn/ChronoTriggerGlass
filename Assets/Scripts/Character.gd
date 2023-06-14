extends CharacterBody2D


const SPEED = 170
var actualSpeed = 0
var inCombat = false
@export var animationDirection = "Down"
var target = null
@export var hasControl = true
@export var playing =  ""
@export var flipped = false
@export var animSpeed = 1.0

func _physics_process(delta):
	move()
	interact()
	animate()

func move():
	if !hasControl:
		return
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
	if !inCombat:
		direction = direction.normalized()
	velocity = direction * actualSpeed
	
	move_and_slide()
	
func interact():
	if !hasControl:
		return
	if !$Inputs.action1:
		return
	$Inputs.action1 = false
	if inCombat || target==null:
		return
	if TextEngine.messageStatus:
		if get_node("/root/Game/UI/TextBox/Text").visible_ratio <1 :
			get_node("/root/Game/UI/TextBox/Text").visible_ratio = 1
		else:
			TextEngine.next.emit()
	elif target.interaction==0:
		TextEngine.go(target)

func animate():
	if !hasControl:
		$Sprite2D.flip_h = flipped
		$Sprite2D/AnimationPlayer.speed_scale = animSpeed
		$Sprite2D/AnimationPlayer.play(playing)
		return
	if velocity.x>0 && abs(velocity.x)>abs(velocity.y):
		flipped = false
	elif velocity.x<0 && abs(velocity.x)>abs(velocity.y):
		flipped = true
	elif abs(velocity.x)<abs(velocity.y):
		flipped = false
	if inCombat:
		animationDirection = "Side"
	else:
		if abs(velocity.x)>abs(velocity.y):
			animationDirection = "Side"
		elif velocity.y>0 && abs(velocity.x)<abs(velocity.y):
			animationDirection = "Down"
		elif velocity.y<0 && abs(velocity.x)<abs(velocity.y):
			animationDirection = "Up"
	if !$Inputs.modifier and velocity.length() > .1:
		playing="run"+animationDirection
		animSpeed=1.2
	elif $Inputs.modifier and velocity.length() > .1:
			playing="walk"+animationDirection
			animSpeed=0.6
	else:
		playing="idle"+animationDirection
	$Sprite2D/AnimationPlayer.play(playing)
	$Sprite2D.flip_h = flipped
	$Sprite2D/AnimationPlayer.speed_scale = animSpeed


func _on_area_2d_area_entered(area):
	target = area.get_parent()


func _on_area_2d_area_exited(area):
	TextEngine.done.emit()
	target = null
