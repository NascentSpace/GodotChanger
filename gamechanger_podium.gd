extends Node3D

@export var Text : Label3D
@export var ID : int
@export var Profile : MeshInstance3D

var players_left_to_reveal : int

func _ready() -> void:
	Global.ScoreChange.connect(_update)
	Global.RevealPlayer.connect(_add_profile)
	Profile.hide()
	players_left_to_reveal = Global.player_count

func _update(eID, score):
	if eID == ID:
		Text.text = str(score)

func _add_profile():
	if players_left_to_reveal <= ID:
		var mat = StandardMaterial3D.new()
		mat.albedo_texture = Global.playerpics[ID-1]
		Profile.set_surface_override_material(0,mat)
		Profile.show()
	players_left_to_reveal -= 1
