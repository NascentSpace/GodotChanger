extends Node3D

@export var SFX : AudioStreamPlayer
@export var Anim : AnimationPlayer
@export var IntroAnim : AnimationPlayer
@export var Music : AudioStreamPlayer
@export var IntroSong : AudioStream
@export var OutroSong : AudioStream
@export var AmbientMusic : AudioStream
@export var GoodDing : AudioStream
@export var BadDing : AudioStream
@export var Cam : Camera3D

@export var Env : WorldEnvironment
@export var TempProfile : MeshInstance3D
@export var Host : MeshInstance3D

@export var Target : Node3D
var smooth_rotation : Vector3
@export var CamPositions : Array[Node3D]
var campos : Vector3

@export var PodiumTscn : PackedScene
var PodiumList : Array
@export var path : Path3D

var targetfov = 42.0
var LightList

var camtarget = Vector3()
var Players : int = 7

func _ready() -> void:
	if Global.LowGraphics:
		_set_graphics()
	
	$Lights/SpotLight3D4.light_energy = 0.0
	$Lights/SpotLight3D5.light_energy = 0.0
	$Lights/SpotLight3D6.light_energy = 0.0
	
	Global.SwitchCamera.connect(_camera_trans)
	Global.SwitchCamPos.connect(_cam_position_change)
	Global.GoodSound.connect(_good_sound)
	Global.BadSound.connect(_bad_sound)
	Global.PlayOpener.connect(_opener)
	Global.IntroPlayer.connect(_begin_entrance)
	Global.Ending.connect(_ending)
	Anim.animation_finished.connect(_intro_done)
	IntroAnim.animation_finished.connect(_entrance_done)
	
	Global.lightstoggled.connect(_toggle_lights)
	Global.changelightclr.connect(_set_light_clr)
	
	Global.changefov.connect(_change_fov)
	
	Players = Global.player_count
	_add_podiums()
	LightList = get_tree().get_nodes_in_group("Lights")

func _set_graphics():
	Env.environment.fog_enabled = false
	Env.environment.volumetric_fog_enabled = false
	Env.environment.ssao_enabled = false
	Env.environment.ssil_enabled = false
	Env.environment.glow_enabled = false
	Env.environment.ssr_enabled = false
	Env.environment.sdfgi_enabled = false
	$GPUParticles3D.amount = 500
	

#FIXME smoothcam snapping
func _process(delta: float) -> void:
	if Global.Smoothcam:
		smooth_rotation = smooth_rotation.lerp(Target.rotation, delta * 5)
		Cam.global_rotation = smooth_rotation
		
	Cam.fov = lerpf(Cam.fov,targetfov,delta*3)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("QUIT"):
		get_tree().quit()

func _intro_done(_string):
	print("animationfinished")
	Global.ControlPanelUnlock.emit()

func _add_podiums():
	for i in range(1,Global.player_count+1):
		var podium = PodiumTscn.instantiate()
		var dist = path.curve.get_point_position(0).distance_to(path.curve.get_point_position(1))
		path.add_child(podium)
		podium.ID = i
		
		podium.global_position = path.global_position + Vector3(0.0, 0.0, (dist/Global.player_count)*i)
		if Global.player_count == 1:
			podium.global_position = path.global_position + Vector3(0.0, 0.0, (dist/2))
		
		PodiumList.append(podium)

func _opener():
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = Global.HostPFP
	Host.set_surface_override_material(0,mat)
	Music.stream = IntroSong
	Music.play()
	Anim.speed_scale = 3.0
	Anim.play("Intro")

func _good_sound():
	SFX.stream = GoodDing
	SFX.play()

func _bad_sound():
	SFX.stream = BadDing
	SFX.play()

func _begin_entrance():
	if IntroAnim.is_playing():
		IntroAnim.stop(false)
	
	var blurb = load("res://assets/dialogue/intro_blurb.dialogue")

	if Players > 0:
		if Global.blurbson:
			IntroAnim.play("Entrance")
		else:
			IntroAnim.play("Entrance_2")
		await get_tree().create_timer(0.1).timeout
		TempProfile.show()
		var mat = StandardMaterial3D.new()
		mat.albedo_texture = Global.playerpics[Players-1]
		TempProfile.set_surface_override_material(0,mat)
		if Global.blurbson:
			Global.DialogueBlurb = Global.playerblurbs[Players-1]
			DialogueManager.show_dialogue_balloon(blurb,"start")
		Players -= 1
		print(str(Players))
	await get_tree().create_timer(6.0).timeout
	Global.Dialoguepush.emit()

func _entrance_done(_string):
	TempProfile.hide()
	Global.RevealPlayer.emit()
	_begin_entrance()

func _ending():
	$GPUParticles3D.emitting = true
	Music.stream = OutroSong
	Music.play()

func _cam_position_change(mark):
	campos = CamPositions[mark].global_position
	_update_cam_position()

func _camera_trans(mark):
	if mark <= 7:
		camtarget = PodiumList[mark-1].global_position + Vector3(0,1.5,0)
	else:
		match mark:
			8:
				camtarget = $Television.global_position
	_update_cam_position()

func _update_cam_position():
	Target.look_at_from_position(campos,camtarget,Vector3.UP)
	Cam.look_at_from_position(campos,camtarget,Vector3.UP)

func _toggle_lights(switch):
	for lights in LightList:
		if switch:
			lights.light_energy = 13.0
		else:
			lights.light_energy = 0.0

func _set_light_clr(clr):
	for lights in LightList:
		lights.light_color = clr

func _change_fov(FOV):
	targetfov = FOV
