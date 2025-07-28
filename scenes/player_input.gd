extends Panel

@export var ID : int

@export var namelabel : Label
@export var TextInput : TextEdit
@export var PlayerImage : TextureRect
@export var MousePanel : Panel

var Hovered : bool = false

func _ready() -> void:
	get_tree().get_root().files_dropped.connect(_on_file_dropped)
	TextInput.text_changed.connect(_name_change)
	namelabel.text = "Player " + str(ID)

func _name_change():
	Global.playernames[ID-1] = TextInput.text

func _on_file_dropped(files):
	get_window().grab_focus()
	if MousePanel.get_global_rect().has_point(MousePanel.get_global_mouse_position()):
		Hovered = true
	else:
		Hovered = false

	await get_tree().create_timer(0.05).timeout
	if Hovered:
		print("File Drop Attempted"+str(ID))
		var path = files[0]
		var image = Image.new()
		image.load(path)
		print(str(image.load(path)))
		var image_texture = ImageTexture.new()
		image_texture.set_image(image)
		PlayerImage.texture = image_texture
		PlayerImage.show()
		Global.playerpics[ID-1] = image_texture
		print(str(Global.playerpics[ID-1])+str(ID-1))
