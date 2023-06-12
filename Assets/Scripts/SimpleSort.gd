extends Sprite2D

var target

func _on_area_2d_body_entered(body):
	target = body
		
func _physics_process(delta):
	if target==null:
		return
	if target.global_position.y<global_position.y+15:
		target.get_node("Sprite2D").z_index=4
	else:
		target.get_node("Sprite2D").z_index=6


func _on_area_2d_body_exited(body):
	target = null
