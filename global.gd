extends Node

var player_count : int = 3
@export var playerpics : Array[Texture]
@export var playernames : Array[String]
var playerblurbs : Array[String] = ["test1","test2","test3","test4","test5","test6","test7",]
var DialogueBlurb : String = "why wont you workkkk"
var blurbson : bool = false

var HostPFP : ImageTexture

var LowGraphics : bool = false

var Smoothcam : bool = false

signal ControlPanelUnlock

signal ScoreChange
signal GoodSound
signal BadSound

signal lightstoggled
signal changelightclr

signal changefov

signal IntroPlayer
signal RevealPlayer
signal PlayOpener
signal ScreenText
signal SwitchCamera
signal SwitchCamPos
signal Ending

signal Dialoguepush
