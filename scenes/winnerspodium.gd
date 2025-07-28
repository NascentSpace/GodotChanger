extends Node3D

@export var first : MeshInstance3D
@export var second : MeshInstance3D
@export var third : MeshInstance3D

var firstplace : int = 0
var secondplace : int = 1
var thirdplace : int = 2

var firstscore : int = 0
var secondscore : int = 0
var thirdscore : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	Global.Ending.connect(_finish)

#The worst code I've ever written!
func _finish():
	await get_tree().create_timer(0.1).timeout
	self.show()
	for i in Global.Scoreboard.size():
		if Global.Scoreboard[i] >= firstscore:
			thirdscore = secondscore
			secondscore = firstscore
			firstscore = Global.Scoreboard[i]
			thirdplace = secondplace
			secondplace = firstplace
			firstplace = i
		elif Global.Scoreboard[i] >= secondscore:
			thirdscore = secondscore
			secondscore = Global.Scoreboard[i]
			thirdplace = secondplace
			secondplace = i
		elif Global.Scoreboard[i] >= thirdscore:
			thirdscore = Global.Scoreboard[i]
			thirdplace = i
	_1add_profile(firstplace)
	_2add_profile(secondplace)
	_3add_profile(thirdplace)



func _1add_profile(ID):
	print(str(ID))
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = Global.playerpics[ID]
	print(str(Global.playerpics[ID]))
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	first.set_surface_override_material(0,mat)

func _2add_profile(ID):
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = Global.playerpics[ID]
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	second.set_surface_override_material(0,mat)

func _3add_profile(ID):
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = Global.playerpics[ID]
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	third.set_surface_override_material(0,mat)
