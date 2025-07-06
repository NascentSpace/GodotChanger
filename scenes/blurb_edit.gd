extends Panel

@export var ID : int
@export var Name : Label
@export var Tedit : TextEdit
@export var Initializer : Control

func _ready() -> void:
	Initializer.UpdateBlurbs.connect(_update)

func _update():
	Global.playerblurbs[ID] = Tedit.text
	Name.text = Global.playernames[ID]
	Tedit.text = Global.playerblurbs[ID]
