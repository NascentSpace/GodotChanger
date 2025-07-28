extends VBoxContainer

@export var Nametag : Button
@export var Tedit : LineEdit
@export var Plus : Button
@export var Minus : Button
@export var ID : int
@export var Pic : TextureRect

var score : int

func _ready() -> void:
	Nametag.disabled = true
	Nametag.pressed.connect(_camswitch)
	Plus.pressed.connect(_plus)
	Minus.pressed.connect(_minus)
	Tedit.text_changed.connect(_textset)
	Nametag.text = Global.playernames[ID-1]
	Pic.texture = Global.playerpics[ID-1]
	Global.ControlPanelUnlock.connect(_unlock)
	Global.Ending.connect(_count_scores)

func _input(event: InputEvent) -> void:
	var num_just_pressed : int = 0
	if event is InputEventKey:
		if event.pressed and event.physical_keycode >= KEY_0 and event.physical_keycode <= KEY_9:
			num_just_pressed = (event.physical_keycode - KEY_0)
	if num_just_pressed == ID:
		if Input.is_action_pressed("shift"):
			_minus()
		elif Input.is_action_just_pressed("ctrl"):
			_plus()

func _unlock():
	Nametag.disabled = false

func _plus():
	score = score + 1
	_score_change()
	Global.GoodSound.emit()

func _minus():
	score = score - 1
	_score_change()
	Global.BadSound.emit()

func _textset():
	print("text changed")
	score = int(Tedit.text)

func _score_change():
	Tedit.text = str(score)
	Global.ScoreChange.emit(ID, score)

func _camswitch():
	Global.SwitchCamera.emit(ID)

func _count_scores():
	Global.Scoreboard[ID-1] = score
