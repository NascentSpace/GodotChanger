extends Window

@export var PlayerPanels : Array[VBoxContainer]

@export var StartButton : Button
@export var AddPlayer : Button
@export var SmoothCam : CheckButton

@export var LightsOn : CheckButton
@export var LightClr : ColorPickerButton

@export var ScreenCam : Button
@export var ScreenApply : Button
@export var ScreenText : TextEdit

@export var TimerToggle : CheckButton
@export var Countdown : CheckButton
@export var TimerAmount : LineEdit
@export var StartTimer : Button
@export var PauseTimer : Button

@export var EndButton : Button

@export var Camposb1 : Button
@export var Camposb2 : Button

@export var FOVLabel : Label
@export var FOVSlider : HSlider
@export var FOVReset : Button

var ButtonsArray : Array

var pcount = 7

func _ready() -> void:
	StartButton.pressed.connect(_play_opener)
	ScreenApply.pressed.connect(_screen_text_apply)
	AddPlayer.pressed.connect(_add_player)
	EndButton.pressed.connect(_end)
	SmoothCam.toggled.connect(_enable_cam_smoothing)
	Global.ControlPanelUnlock.connect(_unlock_ui)
	
	Camposb1.pressed.connect(_pos_change.bind(0))
	Camposb2.pressed.connect(_pos_change.bind(1))
	
	LightsOn.toggled.connect(_toggle_lights)
	LightClr.color_changed.connect(_light_clr_changed)
	
	FOVSlider.value_changed.connect(_fov_changed)
	FOVReset.pressed.connect(_fov_changed.bind(42.0))
	FOVLabel.text = "42.0"
	
	ButtonsArray = [StartButton,AddPlayer,ScreenCam,ScreenApply,EndButton]
	
	for i in PlayerPanels.size():
		if i <= Global.player_count:
			PlayerPanels[i].show()
		if i >= Global.player_count:
			PlayerPanels[i].hide()

func _unlock_ui():
	for i in ButtonsArray.size():
		ButtonsArray[i].set("disabled",false)

func _play_opener():
	Global.PlayOpener.emit()

func _screen_text_apply():
	var text = ScreenText.text
	Global.ScreenText.emit(text)

func _add_player():
	Global.IntroPlayer.emit()

func _enable_cam_smoothing(switch):
	Global.Smoothcam = switch

func _pos_change(ID):
	Global.SwitchCamPos.emit(ID)

func _end():
	Global.Ending.emit()

func _toggle_lights(switch):
	Global.lightstoggled.emit(switch)

func _light_clr_changed(clr):
	Global.changelightclr.emit(clr)

func _fov_changed(FOV):
	FOVLabel.text = str(FOV)
	Global.changefov.emit(FOV)
