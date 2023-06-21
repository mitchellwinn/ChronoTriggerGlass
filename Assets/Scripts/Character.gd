extends CharacterBody2D

const SPEED = 170
var actualSpeed = 0
@export var inCombat = false
var overworld = false
@export var animationDirection = "Down"
var target = null
@export var hasControl = false
@export var camControl = true
@export var playing =  ""
@export var flipped = false
@export var animSpeed = 1.0
var stairDirection = Vector2.ZERO
var currentStair = ""

func _ready():
	hasControl = true

func _physics_process(delta):
	if $Stats.playerSlot == 1 && camControl:
		get_node("/root/Game/Camera2D").global_position = global_position
	cutsceneAid()
	if $Stats.ownerOf:
		move()
		interact()
	animate()

func cutsceneAid():
	if !hasControl:
		return
	var animation = get_node("/root/Game/Cutscenes").get_animation("gatoFightStart")
	var track = animation.find_track("Crono:position",0)
	animation.track_set_key_value(track,0,position)
	
	animation = get_node("/root/Game/Cutscenes").get_animation("gatoFightStart")
	track = animation.find_track("Camera2D:position",0)
	animation.track_set_key_value(track,0,position)
	
	animation = get_node("/root/Game/Cutscenes").get_animation("leaveFair")
	track = animation.find_track("Crono:position",0)
	animation.track_set_key_value(track,0,position)

func enterCombat():	
	hasControl=false
	playing = "enterCombat"
	await get_tree().create_timer(0.8).timeout
	hasControl=true
	inCombat = true

func leaveCombat():
	hasControl=false
	playing = "leaveCombat"
	await get_tree().create_timer(0.8).timeout
	hasControl=true
	inCombat = false

func stairs():
	if velocity == Vector2.ZERO:
		#stairDirection = Vector2.ZERO
		return
	if currentStair == "left":
		animationDirection = "Side"
		if velocity.x<0:
			stairDirection = Vector2(0,-.9)
		elif velocity.x>0:
			stairDirection = Vector2(0,.9)
	elif currentStair == "right":
		animationDirection = "Side"
		if velocity.x<0:
			stairDirection = Vector2(0,.9)
		elif velocity.x>0:
			stairDirection = Vector2(0,-.9)

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
	if overworld:
		actualSpeed = 50
	elif $Inputs.modifier:
		actualSpeed = SPEED/2
	else:
		actualSpeed = SPEED
	if !inCombat:
		stairs()
		if direction==Vector2.ZERO:
			stairDirection = direction
		direction = (direction+stairDirection).normalized()
	velocity = direction * actualSpeed
	
	move_and_slide()

func teleport(destination, toOverworld, facing, cutscene, track):
	target = null
	hasControl =  false
	playing="idle"+animationDirection
	if cutscene == "":
		await CinematicControl.fadeToBrown(10)
	else:
		get_node("/root/Game/Cutscenes").play(cutscene)
		await get_tree().create_timer(1.5).timeout
	if toOverworld:
		$Sprite2D.visible = false
		$MapSprite.visible = true
		overworld = true
	else:
		$Sprite2D.visible = true
		$MapSprite.visible = false
		overworld = false
	get_node("/root/Game/Camera2D").drag_horizontal_enabled = false
	get_node("/root/Game/Camera2D").drag_vertical_enabled = false
	get_node("/root/Game/Camera2D").position_smoothing_speed = 150
	position = destination
	await get_tree().create_timer(0.1).timeout
	get_node("/root/Game/Camera2D").position_smoothing_speed = 6
	get_node("/root/Game/Camera2D").drag_horizontal_enabled = true
	get_node("/root/Game/Camera2D").drag_vertical_enabled = true
	await get_tree().create_timer(0.1).timeout
	animationDirection = facing
	if facing == "Left":
		animationDirection = "Side"
		flipped = true
	if facing == "Right":
		animationDirection = "Side"
		flipped = false
	if cutscene == "":
		playing="idle"+animationDirection
	if get_node("/root/Game/Music").stream!=load(track):
		get_node("/root/Game/Music").stream = load(track)
		get_node("/root/Game/Music").play()
	await CinematicControl.fadeFromBrown(5)
	hasControl = true

func interact():
	if !$Inputs.action1:
		return
	$Inputs.action1 = false
	if inCombat:
		return
	if TextEngine.messageStatus:
		if get_node("/root/Game/UI/TextBox/Text").visible_ratio <1 :
			get_node("/root/Game/UI/TextBox/Text").visible_ratio = 1
		else:
			TextEngine.next.emit()
	elif target==null:
		return
	elif target.interaction==0 and hasControl:
		TextEngine.go(target)
	elif target.interaction==1 and hasControl:
		teleport(target.teleportTo,target.toOverworld, target.facing, target.cutscene, target.newTrack)

func animate():
	if !hasControl:
		$Sprite2D.flip_h = flipped
		$Sprite2D/AnimationPlayer.speed_scale = animSpeed
		$Sprite2D/AnimationPlayer.play(playing)
		if $MapSprite && overworld:
			$MapSprite/AnimationPlayer.play(playing)
		return
	if velocity.x>0 && abs(velocity.x)>abs(velocity.y):
		flipped = false
	elif velocity.x<0 && abs(velocity.x)>abs(velocity.y):
		flipped = true
	elif abs(velocity.x)<abs(velocity.y):
		flipped = false
	if inCombat:
		animationDirection = "Side"
	elif currentStair == "left":
		if velocity.x>0:
			flipped = false
		elif velocity.x<0:
			flipped = true
		animationDirection = "Side"
	else:
		if abs(velocity.x)>abs(velocity.y):
			animationDirection = "Side"
		elif velocity.y>0 && abs(velocity.x)<abs(velocity.y):
			animationDirection = "Down"
		elif velocity.y<0 && abs(velocity.x)<abs(velocity.y):
			animationDirection = "Up"
	if ($Inputs.modifier or overworld) and velocity.length() > .1:
			playing="walk"+animationDirection
			animSpeed=0.6
	elif !$Inputs.modifier and velocity.length() > .1:
		playing="run"+animationDirection
		animSpeed=1.2
	else:
		playing="idle"+animationDirection
	$Sprite2D/AnimationPlayer.play(playing)
	if $MapSprite:
			$MapSprite/AnimationPlayer.play(playing)
			$MapSprite.flip_h = flipped
	$Sprite2D.flip_h = flipped
	$Sprite2D/AnimationPlayer.speed_scale = animSpeed

func _on_area_2d_area_entered(area):
	if area.collision_layer==2:#touch an NPC
		target = area.get_parent()
		print("assigned target NPC")
	elif area.collision_layer==4:
		enterCombat()
	elif area.collision_layer==8:
		currentStair = area.risingDirection
	elif area.collision_layer==16 and area.onTouch:
		teleport(area.teleportTo,area.toOverworld,area.facing, area.cutscene, area.newTrack)
	elif area.collision_layer==16 and !area.onTouch:#touch a warp
		target = area

func _on_area_2d_area_exited(area):
	if area.collision_layer==8:
		currentStair =""
		stairDirection = Vector2.ZERO
	if area.collision_layer==2:
		TextEngine.done.emit()
		if target == area.get_parent():
			target = null
	if area.collision_layer==16:
		if target == area:
			target = null
	elif area.collision_layer==4:
		leaveCombat()

