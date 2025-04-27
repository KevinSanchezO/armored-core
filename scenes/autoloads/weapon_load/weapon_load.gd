extends Node


#primary weapons
const _RIFLE := "res://scenes/game_objects/weapons/range_weapons/rifle/rifle.tscn"
const _SHOTGUN := "res://scenes/game_objects/weapons/range_weapons/shotgun/shotgun.tscn"
const _BATTLE_RIFLE := "res://scenes/game_objects/weapons/range_weapons/battle_rifle/battle_rifle.tscn"

var available_primary_weapons := [
	_BATTLE_RIFLE,
	_RIFLE
]


#support weapons
const GATLING := "res://scenes/game_objects/weapons/range_weapons/gatling/gatling.tscn"

var available_support_weapon = GATLING
