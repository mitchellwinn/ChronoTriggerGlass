extends CharacterBody2D


const SPEED = 300.0


@export var interaction = 0 #0:Dialogue,
@export var defaultAnimation = ""
@export var interactAnimation = ""
@export var currentAnimation = ""
@export var flipped = false
@export var dialogueTreeKey = 0
@export var dialogueTrees = {}
@export var hostile = false
var talking = false

func _ready():
	$Sprite2D/AnimationPlayer.play(defaultAnimation)

func _physics_process(delta):
	move()
	animate()
	if hostile:
		$HostileRange/CollisionShape2D.disabled = false
	else: 
		$HostileRange/CollisionShape2D.disabled = true
func move():
	velocity = Vector2.ZERO
	
func animate():
	if get_node("/root/Game/Cutscenes").is_playing():
		defaultAnimation = currentAnimation
		$Sprite2D.flip_h=flipped
		$Sprite2D/AnimationPlayer.play(currentAnimation)
		return
	if talking:
		currentAnimation = interactAnimation
	else:
		currentAnimation = defaultAnimation
	$Sprite2D/AnimationPlayer.play(currentAnimation)
	$Sprite2D.flip_h=flipped
