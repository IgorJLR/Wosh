extends Control

var popup_active = false

var quiz_title_active = true

var animation_speed = 0.05

onready var screen_size = OS.window_size

# Called when the node enters the scene tree for the first time.
func _ready():
	print(OS.window_size)
	resize()

func positions_setter():
	$MargemPopup/FecharTop.rect_position = Vector2(329.371, 50.96)
	$MargemPopup/FecharTop2.rect_position = Vector2(250, 310)
	$MargemPopup/ComecarButton.rect_position = Vector2(55, 310)

func resize():
	print(screen_size)
	var resizer = ((screen_size.x + screen_size.y) * 0.5) * 0.0015
	print(resizer)
	$MargemPopup.rect_scale = Vector2(resizer, resizer)
	positions_setter()

func _process(delta):
	
	if screen_size != OS.window_size:
		screen_size = OS.window_size
		resize()
	
	if $MargemPopup.modulate.a < 0.99 and popup_active:
		positions_setter()
		if !$MargemPopup.visible:
			$MargemPopup.visible = true
		$MargemPopup.set_modulate(Color($MargemPopup.modulate.r,$MargemPopup.modulate.g,$MargemPopup.modulate.b,$MargemPopup.modulate.a+animation_speed))
		
	if $MargemPopup.modulate.a > 0.1 and !popup_active:
		positions_setter()
		if $MargemPopup.modulate.a < 0.2:
			$MargemPopup.visible = false
		$MargemPopup.set_modulate(Color($MargemPopup.modulate.r,$MargemPopup.modulate.g,$MargemPopup.modulate.b,$MargemPopup.modulate.a-animation_speed))




func _on_Timer_timeout():
	positions_setter()
