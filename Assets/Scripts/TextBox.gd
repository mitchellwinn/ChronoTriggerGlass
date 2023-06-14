extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	disappearInstant()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func disappearInstant():
	scale = Vector2(1,0)

func appearInstant():
	scale = Vector2(1,0)

func disappear(speed):
	while scale.y>0.1:
		scale = Vector2(1,move_toward(scale.y,0,speed))
		await get_tree().create_timer(.01).timeout
	scale = Vector2(1,0)
func appear(speed):
	while scale.y<.9&&TextEngine.messageStatus==true:
		scale = Vector2(1,move_toward(scale.y,1,speed))
		await get_tree().create_timer(.01).timeout
	scale = Vector2(1,1)

