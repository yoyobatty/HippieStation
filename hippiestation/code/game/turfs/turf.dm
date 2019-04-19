/turf
	var/elevation = 10
	var/pinned = null
	var/list/mob/living/old_living = list() //List of mobs that used to be on this turf.

/turf/Destroy()
	if (pinned)
		var/mob/living/carbon/human/H = pinned

		if (istype(H))
			H.anchored = FALSE
			H.pinned_to = null
			H.do_pindown(src, 0)
			H.update_mobility()

			for (var/obj/item/stack/rods/R in H.contents)
				if (R.pinned)
					R.pinned = null
		pinned = null
	return ..()

/turf/Initialize()
	. = ..()
	check_hippie_icon()

/turf/Exited(var/atom/exiter,var/atom/old_loc)
	..()
	if(isliving(exiter))
		var/mob/living/L = exiter
		if(L.old_turf)
			L.old_turf.old_living -= L
		L.old_turf = src
		old_living += L

/proc/get_dist_between_living(var/mob/living/L1,var/mob/living/L2)

	var/best_distance = get_dist(L1,L2)
	if(!isliving(L1) || !isliving(L2))
		return
	if(L1.movement_delay() > 0 && L2.movement_delay() > 0)
		var/calc1 = get_dist(L1.old_turf,L2)
		var/calc2 = get_dist(L1,L2.old_turf)
		if(calc1 < best_distance)
			best_distance = calc1
		if(calc2 < best_distance)
			best_distance = calc1

	else if(L1.movement_delay() > 0)
		var/calc = get_dist(L1.old_turf,L2)
		if(calc < best_distance)
			best_distance = calc

	else if(L2.movement_delay() > 0)
		var/calc = get_dist(L1,L2.old_turf)
		if(calc < best_distance)
			best_distance = calc

	return best_distance