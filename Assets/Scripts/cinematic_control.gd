extends Node


func fadeFromBrown( speed ):
	var brown = get_node("/root/Game/Camera2D/BrownOverlay")
	while brown.modulate.a > 0:
		brown.modulate.a -= 0.01
		await get_tree().create_timer(0.01/speed).timeout
		
func fadeToBrown( speed ):
	var brown = get_node("/root/Game/Camera2D/BrownOverlay")
	while brown.modulate.a < 1:
		brown.modulate.a += 0.03
		await get_tree().create_timer(0.01/speed).timeout
		
func toBrown():
	var brown = get_node("/root/Game/Camera2D/BrownOverlay")
	brown.modulate.a = 1
