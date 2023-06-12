extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	play("0")
	seek(RandomNumberGenerator.new().randf_range(0,0.3))
