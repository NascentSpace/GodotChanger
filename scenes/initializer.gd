extends Control

@export var InputPanels : Array[Panel]

@export var PlayerSlide : HSlider
@export var PlayerCountLabel : Label

@export var StartButton : Button

@export var GraphicSetting : OptionButton
@export var fscreen : CheckBox

@export var VolumeDisplay : Label
@export var AudioSlide : HSlider
@export var SFXon : CheckBox
@export var OpenAudioPanel : Button

@export var BlurbCheck : CheckButton
@export var BlurbMenu : Button
@export var BlurbMenuOverlay : TextureRect
@export var BlurbBack : Button
@export var BlurbList : Array[Panel]

@export var WindowName : LineEdit
@export var WindowNameButton : Button

signal UpdateBlurbs

func _ready() -> void:
	PlayerSlide.value_changed.connect(_player_count_change)
	StartButton.pressed.connect(_begin)
	GraphicSetting.item_selected.connect(_set_graphics)
	fscreen.toggled.connect(_fullscreen)

	AudioSlide.value_changed.connect(_change_audio)
	VolumeDisplay.text = str(AudioServer.get_bus_volume_db(0))
	
	BlurbCheck.toggled.connect(_activate_blurbs)
	BlurbMenu.pressed.connect(_open_blurb_menu)
	BlurbBack.pressed.connect(_open_blurb_menu)
	BlurbMenuOverlay.hide()
	var BlurbList = get_tree().get_nodes_in_group("Blurbs")
	
	WindowName.text_submitted.connect(_window_name_change)
	WindowNameButton.pressed.connect(_window_name_change.bind("GameChanger"))

#region Blurbs

func _open_blurb_menu():
	BlurbMenuOverlay.visible = !BlurbMenuOverlay.visible
	UpdateBlurbs.emit()

func _activate_blurbs(switch):
	Global.blurbson = switch
	BlurbMenu.disabled = !BlurbMenu.disabled

#endregion

func _player_count_change(val):
	var amount = int(val)
	Global.player_count = amount
	PlayerCountLabel.text = str(amount)
	print(str(amount))

	for i in InputPanels.size():
		if i <= amount:
			InputPanels[i].show()
			BlurbList[i].show()
		if i >= amount:
			InputPanels[i].hide()
			BlurbList[i].hide()

#region Graphics

func _set_graphics(set_id):
	if set_id == 1:
		Global.LowGraphics = true
	else:
		Global.LowGraphics = false

func _fullscreen(val):
	if val:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	if !val:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#endregion

#region Audio

func _change_audio(db):
	AudioServer.set_bus_volume_db(0,db)
	VolumeDisplay.text = str(db)

#endregion

#TODO add a really snazzy intro animation, low priority

func _window_name_change(_string):
	if WindowName.text != null:
		DisplayServer.window_set_title(WindowName.text)

func _begin():
	Global.Scoreboard.resize(Global.player_count)
	get_tree().change_scene_to_file("res://set.tscn")
