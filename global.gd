extends Node

var player_count : int = 3
@export var playerpics : Array[Texture]
@export var playernames : Array[String]
var playerblurbs : Array[String] = ["test1","test2","test3","test4","test5","test6","test7","test8"]
var DialogueBlurb : String = "why wont you workkkk"
var blurbson : bool = false

var HostPFP : ImageTexture

var LowGraphics : bool = true
var TimerTime : int = 60
var TimerStopwatch : bool = false
var TimerSoundToggle : bool = true
var CustomTimeSound : AudioStream

var DefaultFOV : float = 42.0
var Smoothcam : bool = false

var Scoreboard : Array = [0,0,0,0,0,0,0,0]

signal ControlPanelUnlock

signal ScoreChange
signal GoodSound
signal BadSound

signal lightstoggled
signal changelightclr
signal discotoggled

signal changefov

#Signals for the timer
signal timertoggle
signal timerstart
signal timerreset
signal wheelvisibility
#
signal IntroPlayer #Begin introducing players
signal RevealPlayer
signal PlayOpener 
signal ScreenText
signal SwitchCamera
signal SwitchCamPos
signal Ending

signal Dialoguepush
