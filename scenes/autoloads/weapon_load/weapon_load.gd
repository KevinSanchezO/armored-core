extends Node


#primary weapons
const _RIFLE := "res://scenes/game_objects/weapons/range_weapons/rifle/rifle.tscn"
const _SHOTGUN := "res://scenes/game_objects/weapons/range_weapons/shotgun/shotgun.tscn"
const _BATTLE_RIFLE := "res://scenes/game_objects/weapons/range_weapons/battle_rifle/battle_rifle.tscn"
const _ASSAULT_ENERGY := "res://scenes/game_objects/weapons/range_weapons/assault_energy_rifle/assault_energy_rifle.tscn"
const _REVOLVER_ENERGY := ""

var available_primary_weapons := [
	_RIFLE,
	_SHOTGUN
]


#support weapons
const _CHAINSAW := "res://scenes/game_objects/weapons/melee_weapons/chainsaw/chainsaw.tscn"
const _GAUTLENT := ""
const _GATLING := "res://scenes/game_objects/weapons/range_weapons/gatling/gatling.tscn"
const _PILE_BUNKER := ""
const _KATANA := ""
const _MISSILE_LAUNCHER := ""
const _ENERGY_SWORD := "res://scenes/game_objects/weapons/melee_weapons/energy_sword/energy_sword.tscn"
const _ENERGY_SPEAR := ""
const _RAIL_CANNON := "res://scenes/game_objects/weapons/range_weapons/rail_cannon/rail_cannon.tscn"

var available_support_weapon = _CHAINSAW
