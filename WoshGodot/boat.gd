extends KinematicBody

var movement_control = true

var direction = Vector3.BACK
var velocity = Vector3.ZERO
var strafe_dir = Vector3.ZERO
var strafe = Vector3.ZERO

var aim_turn = 0

var vertical_velocity = 0
var gravity = 0

var movement_speed = 0
var walk_speed = 1.5
var run_speed = 5
var acceleration = 6
var angular_acceleration = 2

func _ready():
	direction = Vector3.BACK.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y)
	# Sometimes in the level design you might need to rotate the Player object itself
	# So changing the direction at the beginning


func input_movement(active, event):
	if active:
		if event is InputEventMouseMotion:
			aim_turn = -event.relative.x * 0.015 #animates player with mouse movement while aiming (used in line 104)

func delta_movement(active, delta):
	if active:
		
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(direction.x, direction.z) - (rotation.y +3.135), delta * angular_acceleration)
		#$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, $Camroot/h.rotation.y, delta * angular_acceleration)
		
		var h_rot = $Camroot/h.global_transform.basis.get_euler().y
		
		if Input.is_action_pressed("ui_up") ||  Input.is_action_pressed("ui_down") ||  Input.is_action_pressed("ui_left") ||  Input.is_action_pressed("ui_right"):
			
			direction = Vector3(0,
			0,
			Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))

			strafe_dir = direction
			
			direction = direction.rotated(Vector3.UP, h_rot).normalized()
			
			movement_speed = walk_speed

		else:
	#		$AnimationTree.set("parameters/iwr_blend/blend_amount", lerp($AnimationTree.get("parameters/iwr_blend/blend_amount"), -1, delta * acceleration))
			movement_speed = 0
			strafe_dir = Vector3.ZERO
			
		
		velocity = lerp(velocity, direction * movement_speed, delta * acceleration)

		move_and_slide(velocity + Vector3.DOWN * vertical_velocity, Vector3.UP)
		
		if !is_on_floor():
			vertical_velocity += gravity * delta
		else:
			vertical_velocity = 0
		
		
		
		
		strafe = lerp(strafe, strafe_dir + Vector3.RIGHT * aim_turn, delta * acceleration)
		

		
		var iw_blend = (velocity.length() - walk_speed) / walk_speed
		var wr_blend = (velocity.length() - walk_speed) / (run_speed - walk_speed)

		#find the graph here: https://www.desmos.com/calculator/4z9devx1ky


		
		aim_turn = 0
		
		
	#	$Status/Label.text = "direction : " + String(direction)
	#	$Status/Label2.text = "direction.length() : " + String(direction.length())
	#	$Status/Label3.text = "velocity : " + String(velocity)
	#	$Status/Label4.text = "velocity.length() : " + String(velocity.length())

func _input(event):
	
	input_movement(movement_control, event)


func _physics_process(delta):
	
	delta_movement(movement_control, delta)
