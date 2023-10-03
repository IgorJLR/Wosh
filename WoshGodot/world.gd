extends Spatial


var b = true
var t = 0
var oceanY = 0


func _ready():
	$WorldEnvironment.environment.background_sky.ground_bottom_color = $TilesRendered.get_child(0).mesh.material.get_shader_param('out_color')
	$WorldEnvironment.environment.background_sky.ground_horizon_color = $TilesRendered.get_child(0).mesh.material.get_shader_param('out_color')
	#$WorldEnvironment.environment.background_sky.sky_top_color = $MeshInstance.mesh.material.get_shader_param('out_color')
	$WorldEnvironment.environment.background_sky.sky_horizon_color = $TilesRendered.get_child(0).mesh.material.get_shader_param('out_color')
	tileRender()
	
	
	

func trickUpdate(amount):
	if (amount != $boat/trickTrack.mesh.material.get_shader_param('amount')):
		$boat/trickTrack.mesh.material.set_shader_param('amount', amount)

func tileRender():

	var dist = 0
	var boatPos = $boat.translation
	var positions = {
		"centro":Vector3(round(boatPos.x * 0.011111) * 90,oceanY,round(boatPos.z * 0.011111) * 90),
		"cima":Vector3((round(boatPos.x * 0.011111) * 90) + 90,oceanY,round(boatPos.z * 0.011111) * 90),
		"baixo":Vector3((round(boatPos.x * 0.011111) * 90) -90,oceanY,round(boatPos.z * 0.011111) * 90),
		"esquerda":Vector3(round(boatPos.x * 0.011111) * 90,oceanY,(round(boatPos.z * 0.011111) * 90) - 90),
		"direita":Vector3((round(boatPos.x * 0.011111) * 90),oceanY,(round(boatPos.z * 0.011111) * 90) + 90),
		"cd":Vector3((round(boatPos.x * 0.011111) * 90) + 90,oceanY,(round(boatPos.z * 0.011111) * 90) + 90),
		"ce":Vector3((round(boatPos.x * 0.011111) * 90) + 90,oceanY,(round(boatPos.z * 0.011111) * 90) - 90),
		"bd":Vector3((round(boatPos.x * 0.011111) * 90) - 90,oceanY,(round(boatPos.z * 0.011111) * 90) + 90),
		"be":Vector3((round(boatPos.x * 0.011111) * 90) - 90,oceanY,(round(boatPos.z * 0.011111) * 90) - 90),
		}
	
	for p in positions:
		if positions[p].distance_to(get_node("TilesRendered/"+p).translation) > 40:
			get_node("TilesRendered/"+p).translation.x = positions[p].x
			get_node("TilesRendered/"+p).translation.z = positions[p].z
			
			
	print(positions)
	

func boatAnimation(active):
	if active:
		t = ($TilesRendered.get_child(0).mesh.material.get_shader_param('amount')*0.5) * sin(OS.get_ticks_msec()*(2*PI*0.0005*$TilesRendered.get_child(0).mesh.material.get_shader_param('amount')))
		$boat.translation.y = (t)+0.8
		
		#$boat.rotation_degrees.x += t*0.1
		#$boat.rotation_degrees.y -= t*0.1
		#$boat.rotation_degrees.z -= t*0.1
		#$boat/Pivot/Camera.rotation_degrees.x -= t*0.1
		#$boat/Pivot/Camera.rotation_degrees.y += t*0.1
		#$boat/Pivot/Camera.rotation_degrees.z += t*0.1


func start_quiz():
	pass

func call_popup():
	$boat/Camroot/h/v/Camera/UI.popup_active = true
	$boat/Camroot/h/v/Camera/UI/MargemPopup.modulate = Color(1,1,1,0.0)
	$boat/Camroot.camera_control = false
	$boat/Camroot.camera_control = false
	$boat.movement_control = false
	$boat/Camroot.camera_mouse_capture(false)

func close_popup():
	$boat/Camroot/h/v/Camera/UI.popup_active = false
	$boat/Camroot/h/v/Camera/UI/MargemPopup.modulate = Color(1,1,1,1)
	$boat/Camroot.camera_control = true
	$boat/Camroot.camera_control = true
	$boat.movement_control = true
	$boat/Camroot.camera_mouse_capture(true)

func _physics_process(delta: float) -> void:
	boatAnimation(true)
	


func _on_TimerRender_timeout():
	tileRender()
	



func _on_islandBody_body_entered(body):
	print("Colisão detectada para a Ilha.")
	var objeto = {"name":body.get_name()}
	if objeto.name == "boat":
		print("Evento da Ilha.")
		call_popup()
		




func _on_FecharTop_button_down():
	close_popup()


func _on_ComecarButton_pressed():
	start_quiz()
