extends Node3D

@export var Text : Label
@export var DisplayImage : TextureRect
@export var Background : ColorRect

func _ready() -> void:
	Global.ScreenText.connect(_change_text)
	pass
	
func _change_text(words):
	Text.text = words

func _on_file_dropped(files):
	print("file drop attempted")
	await get_tree().create_timer(0.01).timeout
	var path = files[0]
	var image = Image.new()
	image.load(path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	DisplayImage.texture = image_texture
	DisplayImage.show()
