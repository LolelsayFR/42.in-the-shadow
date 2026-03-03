extends Node

enum {
	MAIN,
	INGAME,
	PAUSE,
	SETTINGS,
	INGAME_SETTINGS,
	LVL_SELECTOR
}

var lvl:int = 0

var gameState:int = MAIN
