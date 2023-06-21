extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Crono.hasControl = true
	$Crono.camControl = true
	$Cat.hasControl = false
	$Cat.hasControl = false
	#return
	$Crono.hasControl = false
	$Crono.camControl = false
	CinematicControl.toBrown()
	$CronoMom.dialogueTreeKey = 1
	await TextEngine.go($CronoMom)
	$Music.play()
	$Cutscenes.play("cronoWakeUp")
	await get_tree().create_timer(6.1).timeout
	$CronoMom.dialogueTreeKey = 2
	await TextEngine.go($CronoMom)
	await get_tree().create_timer(1.5).timeout
	$Cutscenes.play("cronoWakeUp2")
	await get_tree().create_timer(2).timeout
	$CronoMom.dialogueTreeKey = 3
	await TextEngine.go($CronoMom)
	$Cutscenes.play("cronoWakeUp3")
	await get_tree().create_timer(5.5).timeout
	$Cutscenes.play("cronoWakeUp4")
	$CronoMom.dialogueTreeKey = 4
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("toggleFull"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2(480*2,270*2),0)
		elif DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		print(DisplayServer.window_get_mode())	
	if Input.is_action_just_pressed("debugSkip"):
		if get_node("Cutscenes").is_playing():
			get_node("Cutscenes").seek(999)
