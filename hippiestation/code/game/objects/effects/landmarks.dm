/obj/effect/landmark/start/infiltrator
	name = "infiltrator"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_spawn"

/obj/effect/landmark/start/infiltrator/Initialize()
	..()
	GLOB.infiltrator_start += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/infiltrator_objective
	name = "infiltrator objective items"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_loot"

/obj/effect/landmark/start/infiltrator_objective/Initialize()
	..()
	GLOB.infiltrator_objective_items += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/vice_officer
	name = "Vice Officer"
	icon_state = "x4"

/obj/effect/landmark/maint_spawn
	name = "station maint room map spawn"
	var/datum/map_template/room_type

/obj/effect/landmark/maint_spawn/Initialize(mapload)
	. = ..()
	GLOB.maint_spawn += src
	//return INITIALIZE_HINT_QDEL


/obj/effect/landmark/maint_spawn/test
	name = "test room"
	room_type = /datum/map_template/maint

/obj/effect/landmark/maint_spawn/threebythree
	name = "3x3 spawner"
	room_type = /datum/map_template/maint/threebythree

/obj/effect/landmark/maint_spawn/twobythree
	name = "2x3 spawner"
	room_type = /datum/map_template/maint/twobythree
