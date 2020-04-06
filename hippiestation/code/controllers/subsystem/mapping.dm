/datum/controller/subsystem/mapping/proc/hippie_load_ruins()
	// Generate maintenance room ruins
	//var/list/spawn_locs = list()
	for(var/X in GLOB.maint_spawn)
		//spawn_locs += X
		var/turf/T = get_turf(X) //pick a spot
		var/datum/map_template/template //summon the template variable
		var/obj/effect/landmark/maint_spawn/maint
		maint = X
		template = new maint.room_type
		//log_game("load_ruins template [template] and maint = [maint] and maint.room_type = [maint.room_type]")
		template.load(T, centered = TRUE)
