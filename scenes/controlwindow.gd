extends Window

@export var PlayerPanels : Array[VBoxContainer]

@export_group("Buttons")
@export var StartButton : Button
@export var AddPlayer : Button
@export var EndButton : Button

@export_group("Lights")
@export var LightsOn : CheckButton
@export var LightClr : ColorPickerButton
@export var DiscoToggle : CheckButton

@export_group("Screen")
@export var ScreenApply : Button
@export var ScreenText : LineEdit

@export_group("Timers")
@export var TimerToggle : CheckButton
@export var Stopwatch : CheckButton
@export var WheelVisible : CheckButton
@export var TimerSound : CheckButton
@export var TimerAmount : LineEdit
@export var StartTimer : Button
@export var PauseTimer : Button

@export_group("Camera")
@export var Camposb1 : Button
@export var Camposb2 : Button
@export var ScreenCam : Button
@export var HostCam : Button

@export var SmoothCam : CheckButton
@export var FOVLabel : Label
@export var FOVSlider : HSlider
@export var FOVReset : Button

var ButtonsArray : Array

var pcount = 8

func _ready() -> void:
	StartButton.pressed.connect(_play_opener)
	ScreenApply.pressed.connect(_screen_text_apply.bind("null"))
	ScreenText.text_submitted.connect(_screen_text_apply)
	ScreenCam.pressed.connect(_change_cam_target.bind(9))
	AddPlayer.pressed.connect(_add_player)
	EndButton.pressed.connect(_end)
	SmoothCam.toggled.connect(_enable_cam_smoothing)
	Global.ControlPanelUnlock.connect(_unlock_ui)
	
	Camposb1.pressed.connect(_pos_change.bind(0))
	Camposb2.pressed.connect(_pos_change.bind(1))
	HostCam.pressed.connect(_change_cam_target.bind(10))
	
	LightsOn.toggled.connect(_toggle_lights)
	LightClr.color_changed.connect(_light_clr_changed)
	DiscoToggle.toggled.connect(_disco_mode)
	#TODO Add functionality for disco lights
	
	TimerToggle.toggled.connect(_toggle_timer)
	Stopwatch.toggled.connect(_stopwatch_toggle)
	StartTimer.pressed.connect(_start_timer.bind(true))
	PauseTimer.pressed.connect(_start_timer.bind(false))
	TimerAmount.text_changed.connect(_update_timer_time)
	TimerAmount.text_submitted.connect(_submit_timer)
	WheelVisible.toggled.connect(_timer_wheel)
	TimerSound.toggled.connect(_timer_sound)
	
	FOVSlider.value_changed.connect(_fov_changed)
	FOVReset.pressed.connect(_fov_reset)
	FOVLabel.text = "42.0"
	
	ButtonsArray = [StartButton,AddPlayer,ScreenCam,EndButton]
	
	for i in PlayerPanels.size():
		if i <= Global.player_count:
			PlayerPanels[i].show()
		if i >= Global.player_count:
			PlayerPanels[i].queue_free()

func _unlock_ui():
	for i in ButtonsArray.size():
		ButtonsArray[i].set("disabled",false)

func _play_opener():
	Global.PlayOpener.emit()

func _screen_text_apply(_string):
	var text = ScreenText.text
	Global.ScreenText.emit(text)

func _add_player():
	Global.IntroPlayer.emit()

func _enable_cam_smoothing(switch):
	Global.Smoothcam = switch
	Global.SwitchCamPos.emit(0)
	Global.SwitchCamera.emit(1)

func _pos_change(ID):
	Global.SwitchCamPos.emit(ID)

func _end():
	Global.Ending.emit()

func _toggle_lights(switch):
	Global.lightstoggled.emit(switch)

func _light_clr_changed(clr):
	Global.changelightclr.emit(clr)
	
func _disco_mode(switch):
	Global.discotoggled.emit(switch)

func _fov_reset():
	var fov = Global.DefaultFOV
	FOVSlider.value = fov
	_fov_changed(fov)

func _fov_changed(FOV):
	FOVLabel.text = str(FOV)
	Global.changefov.emit(FOV)

func _toggle_timer(switch):
	Global.timertoggle.emit(switch)

func _stopwatch_toggle(switch):
	Global.TimerStopwatch == switch

func _start_timer(switch):
	_submit_timer(str(Global.TimerTime))
	PauseTimer.disabled = false
	Global.timerstart.emit(switch)

func _reset_timer():
	Global.timerreset.emit()
	PauseTimer.disabled = true

func _timer_wheel():
	pass

func _timer_sound():
	pass

func _change_cam_target(ID):
	Global.SwitchCamera.emit(ID)

func _update_timer_time(text):
	var time = int(float(text))
	if time >= 3600:
		time = 3600
	Global.TimerTime = time
	pass

func _submit_timer(text):
	var time = int(float(text))
	if time >= 3600:
		time = 3600
	Global.TimerTime = time
	TimerAmount.text = time_convert(time)

func time_convert(time_in_sec):
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60
	var hours = (time_in_sec/60)/60
	if hours == 1:
		hours = 0
		minutes = 60
	#returns a string with the format "HH:MM:SS"
	var time = "%02d:%02d:%02d" % [hours, minutes, seconds]
	time = time.lstrip("00:")
	return time
	#return "%02d:%02d:%02d" % [hours, minutes, seconds]
