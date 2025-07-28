extends Control

@export var ProgWheel : ColorRect
@export var TimeDisplay : Label
@export var timer : Timer
@export var sound : AudioStreamPlayer
var moving : bool = false
var wheel_progress : float
var time_elapsed : float

func _ready() -> void:
	Global.timertoggle.connect(_togglevisibility)
	Global.timerstart.connect(_start_timer)
	Global.timerreset.connect(_reset)
	timer.timeout.connect(_end_timer)
	self.hide()
	pass

func _togglevisibility(switch):
	self.visible = switch

func _start_timer(switch):
	if switch:
		if timer.paused:
			timer.paused = false
			moving = true
		else:
			time_elapsed = 0.0
			timer.paused = false
			timer.start(Global.TimerTime)
			_set_wheel(1.0)
			wheel_progress = 1.0
			moving = true
	else:
		if timer.paused:
			timer.paused = false
			moving = true
		timer.paused = true
		moving = false

func _end_timer():
	moving = false
	TimeDisplay.text = "Time's Up!"
	sound.play()

func _reset():
	TimeDisplay.text = _format_seconds(Global.TimerTime,true)
	moving = false
	_set_wheel(1.0)
	wheel_progress = 1.0
	time_elapsed = 0.0
	
func _process(delta: float) -> void:
	if self.visible:
		if moving:
			_move_bar()
			time_elapsed += delta

func _move_bar():
	var remappedtime : float

	if Global.TimerStopwatch:
		remappedtime = remap(timer.time_left,0.0,Global.TimerTime,0.0,1.0)
		TimeDisplay.text = _format_seconds(time_elapsed,true)
	else:
		remappedtime = remap(timer.time_left,0.0,Global.TimerTime,0.0,1.0)
		TimeDisplay.text = _format_seconds(timer.time_left,true)

	_set_wheel(wheel_progress)
	wheel_progress = remappedtime

func _set_wheel(val):
	var mat = ProgWheel.material
	mat.set("shader_parameter/value",val);

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

func _format_seconds(time : float, use_milliseconds : bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)

	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]

	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
