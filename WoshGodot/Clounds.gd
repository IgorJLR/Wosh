extends Particles

var vel = 0.1


func _process(delta):
	$".".rotation_degrees.y += vel * delta
