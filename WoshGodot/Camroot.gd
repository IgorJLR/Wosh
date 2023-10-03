extends Spatial

var camera_control = true

var camrot_h = 0
var camrot_v = 0
var cam_v_max = 75
var cam_v_min = -55
var h_sensitivity = 0.1
var v_sensitivity = 0.1
var h_acceleration = 10
var v_acceleration = 10


func camera_mouse_capture(active):
	if active:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func camera_input(active, event):
	if active:
		if event is InputEventMouseMotion:
			$mouse_control_stay_delay.start()
			camrot_h += -event.relative.x * h_sensitivity
			camrot_v += event.relative.y * v_sensitivity

func delta_movement(active,delta):
	if active:
		camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
		
		var mesh_front = get_node("../Mesh").global_transform.basis.z
		var rot_speed_multiplier = 0.15 #reduce this to make the rotation radius larger
		var auto_rotate_speed =  (PI - mesh_front.angle_to($h.global_transform.basis.z)) * get_parent().velocity.length() * rot_speed_multiplier
		
		if $mouse_control_stay_delay.is_stopped():
			#FOLLOW CAMERA
			$h.rotation.y = lerp_angle($h.rotation.y, get_node("../Mesh").global_transform.basis.get_euler().y, delta * auto_rotate_speed)
			camrot_h = $h.rotation_degrees.y
		else:
			#MOUSE CAMERA
			$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * h_acceleration)
		
		$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, camrot_v, delta * v_acceleration)
		
		if camrot_v < 1:
			$h/v/Camera.far = -8
			$h/v/Camera/waterFog.visible = true
			$h/v/Camera/renderFog.visible = false
		else:
			$h/v/Camera.far = 100
			$h/v/Camera/waterFog.visible = false
			$h/v/Camera/renderFog.visible = true

func _ready():
	
	camera_mouse_capture(true)
	$h/v/Camera.add_exception(get_parent())
	
func _input(event):
	camera_input(camera_control,event)


func _physics_process(delta):
	
	delta_movement(camera_control,delta)
