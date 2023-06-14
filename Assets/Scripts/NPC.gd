extends CharacterBody2D


const SPEED = 300.0

@export var hostile = false
@export var interaction = 0 #0:Dialogue,
@export var defaultAnimation = ""
@export var interactAnimation = ""
@export var dialogueTreeKey = 0
@export var dialogueTrees = {}
var talking = false

func _ready():
	$Sprite2D/AnimationPlayer.play(defaultAnimation)

func _physics_process(delta):
	move()
	animate()

func move():
	velocity = Vector2.ZERO
	
func animate():
	if talking:
		$Sprite2D/AnimationPlayer.play(interactAnimation)
	else:
		$Sprite2D/AnimationPlayer.play(defaultAnimation)
		
