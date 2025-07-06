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
