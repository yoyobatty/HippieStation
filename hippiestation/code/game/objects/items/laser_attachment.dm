/obj/item/laser_attachment
	name = "laser attachment"
	desc = "A low powered laser you attached to weapons to improve aiming"
	icon = 'icons/obj/device.dmi'
	icon_state = "pointer"
	item_state = "pen"
	var/pointer_icon_state
	var/on = FALSE
	var/datum/beam/laserbeam = null
	var/aiming_time_increase_angle_multiplier = 0.3
	var/last_process = 0
	var/lastangle = 0
	var/aiming_lastangle = 0
	actions_types = list(/datum/action/item_action/toggle_light)

/obj/item/laser_attachment/red
	pointer_icon_state = "red_laser"
/obj/item/laser_attachment/green
	pointer_icon_state = "green_laser"
/obj/item/laser_attachment/blue
	pointer_icon_state = "blue_laser"
/obj/item/laser_attachment/purple
	pointer_icon_state = "purple_laser"

/obj/item/laser_attachment/Initialize()
	. = ..()
	if(!pointer_icon_state)
		pointer_icon_state = pick("red_laser","green_laser","blue_laser","purple_laser")
	START_PROCESSING(SSfastprocess, src)

/obj/item/laser_attachment/attack_self(mob/user)
	on = !on
	if(on)
		icon_state = "pointer_[pointer_icon_state]"
	else
		icon_state = initial(icon_state)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()
	return TRUE

/obj/item/laser_attachment/process()
	if(!on)
		return
	refreshBeam()

/obj/item/laser_attachment/proc/refreshBeam()
	var/mob/living/carbon/human/user = loc
	if(!ishuman(user) && !user)
		return
	if(!on)
		return
	process_aim()
	aiming_beam(TRUE)

/obj/item/laser_attachment/proc/process_aim()
	var/mob/living/carbon/human/user = loc
	if(ishuman(user) && user.client && user.client.mouseParams)
		var/angle = mouse_angle_from_client(user.client)
		user.setDir(angle2dir_cardinal(angle))
		lastangle = angle

/obj/item/laser_attachment/proc/aiming_beam(force_update = FALSE)
	var/diff = abs(aiming_lastangle - lastangle)
	var/mob/living/carbon/human/user = loc
	if(!ishuman(user) && !user.client && !user.client.mouseParams)
		return
	if(diff < AIMING_BEAM_ANGLE_CHANGE_THRESHOLD && !force_update)
		return
	aiming_lastangle = lastangle
	var/obj/item/projectile/beam/hitscan/aiming_beam/P = new
	switch(pointer_icon_state)
		if("red_laser")
			P.color = rgb(255, 0, 0)
		if("green_laser")
			P.color = rgb(0, 255, 0)
		if("blue_laser")
			P.color = rgb(0, 0, 255)
		if("purple_laser")
			P.color = rgb(255, 0, 255)
		else
			P.color = rgb(255, 0, 0)
	var/turf/curloc = get_turf(src)
	var/turf/targloc = get_turf(user.client.mouseObject)
	if(!istype(targloc))
		if(!istype(curloc))
			return
		targloc = get_turf_in_angle(lastangle, curloc, 10)
	P.preparePixelProjectile(targloc, user, user.client.mouseParams, 0)
	P.fire(lastangle)

/obj/item/projectile/beam/hitscan
	icon_state = ""
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/tracer/beam_rifle
	var/constant_tracer = FALSE

/obj/item/projectile/beam/hitscan/generate_hitscan_tracers(cleanup = TRUE, duration = 2, impacting = TRUE, highlander)
	set waitfor = FALSE
	for(var/datum/point/p in beam_segments)
		generate_tracer_between_points(p, beam_segments[p], tracer_type, color, duration, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity)
	if(cleanup)
		QDEL_LIST(beam_segments)
		beam_segments = null
		QDEL_NULL(beam_index)

/obj/item/projectile/beam/hitscan/aiming_beam
	tracer_type = /obj/effect/projectile/tracer/tracer/aiming
	name = "aiming beam"
	hitsound = null
	hitsound_wall = null
	nodamage = TRUE
	damage = 0
	constant_tracer = TRUE
	hitscan_light_range = 0
	hitscan_light_intensity = 0
	hitscan_light_color_override = "#99ff99"
	reflectable = REFLECT_FAKEPROJECTILE

/obj/item/projectile/beam/hitscan/aiming_beam/prehit(atom/target)
	qdel(src)

/obj/item/projectile/beam/hitscan/aiming_beam/on_hit()
	qdel(src)