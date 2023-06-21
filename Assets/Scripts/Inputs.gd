extends Node


var left = false
var right = false
var up = false
var down = false
var modifier = false
var action1 = false
var screenCD = 0

func _input(event):
	if event.is_action_pressed("left"):
		left = true
	elif event.is_action_released("left"):
		left = false
	if event.is_action_pressed("right"):
		right = true
	elif event.is_action_released("right"):
		right = false
	if event.is_action_pressed("up"):
		up = true
	elif event.is_action_released("up"):
		up = false
	if event.is_action_pressed("down"):
		down = true
	elif event.is_action_released("down"):
		down = false
	if event.is_action_pressed("modifier"):
		modifier = true
	elif event.is_action_released("modifier"):
		modifier = false
	if event.is_action_pressed("action1"):
		action1 = true
	elif event.is_action_released("action1"):
		action1 = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
