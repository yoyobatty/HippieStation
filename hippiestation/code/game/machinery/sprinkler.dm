#define SPRINKLER_COOLDOWN 150

/obj/machinery/sprinkler
	var/obj/effect/foam_container/dispense_type = /obj/effect/foam_container
	var/detecting = TRUE
	var/last_spray = 0
	var/uses = 10
	var/temp_rating = 400
	layer = LOW_OBJ_LAYER
	plane = FLOOR_PLANE
	icon = 'hippiestation/icons/obj/machines/sprinkler.dmi'
	icon_state = "sprinkler"
	anchored = TRUE
	max_integrity = 300
	integrity_failure = 50
	armor = list("melee" = 20, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 30, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 80)
	resistance_flags = FIRE_PROOF

/obj/machinery/sprinkler/foam
	name = "water sprinkler"
	desc = "Emergency sprinkler that converts water into non-slip firefighting foam used for containing fires."
	dispense_type = /obj/effect/foam_container/firefoam

/obj/machinery/sprinkler/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>It's rated for [temp_rating]C fires. It has <b>[uses]</b> uses remaining.</span>")

/obj/machinery/sprinkler/temperature_expose(datum/gas_mixture/air, temperature, volume)
	if(temperature > T0C + temp_rating && detecting)
		spray()
	..()

/obj/machinery/sprinkler/proc/spray()
	if(stat & BROKEN)
		return
	if(world.time < last_spray+SPRINKLER_COOLDOWN)
		return
	if(!uses)
		return

	last_spray = world.time
	detecting = FALSE
	if(dispense_type)
		dispense_type = new
		dispense_type.Smoke()
	playsound(src,'sound/items/syringeproj.ogg',40,TRUE)
	uses--

/obj/machinery/sprinkler/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.) //damage received
		if(detecting && prob(40))
			spray()

/obj/machinery/sprinkler/wrench_act(mob/user, obj/item/W)
	add_fingerprint(user)
	if(W.use_tool(src, user, 40, volume=50))
		detecting = !detecting
		if(detecting)
			user.visible_message("[user] has reset [src]'s nozzle.", "<span class='notice'>You reset [src]'s nozzle.</span>")
		else
			user.visible_message("[user] has opened [src]'s nozzle!", "<span class='notice'>You open [src]'s nozzle!</span>")
			spray()
		return TRUE

/obj/machinery/sprinkler/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(W.tool_behaviour == TOOL_WRENCH)
		return	//Should stop the sprinkler getting attacked if unwrenching is interrupted
	else if(istype(W,/obj/item/reagent_containers/glass))
		if(uses < 10)
			if(W.reagents.has_reagent("water", 50))
				uses++
				W.reagents.remove_reagent("water", 50)
				user.visible_message("[user] has partly filled [src].", "<span class='notice'>You partly fill [src]. It now has <b>[uses]</b> uses of foam remaining.</span>")
			else
				to_chat(user, "<span class='notice'>This machine only accepts water.</span>")
		else
			to_chat(user, "<span class='notice'>[src] is full!</span>")
		return
	else
		. = ..()

/obj/machinery/sprinkler/gas
	name = "halon sprinkler"
	desc = "Emergency sprinkler used to stop datacenter fires"
	temp_rating = 350
	dispense_type = /obj/effect/foam_container/gas

/obj/effect/foam_container
	name = "foam container"
	icon = 'icons/effects/effects.dmi'
	icon_state = "frozen_smoke_capsule"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pass_flags = PASSTABLE

/obj/effect/foam_container/proc/Smoke()
	return

/obj/effect/foam_container/firefoam
	name = "resin container"
	desc = "A compacted ball of expansive fire fighting foam, used to combat fires."

/obj/effect/foam_container/firefoam/Smoke()
	var/obj/effect/particle_effect/foam/firefighting/F = new
	F.amount = 5
	playsound(src,'sound/effects/bamf.ogg',100,1)
	qdel(src)

/obj/effect/foam_container/gas
	name = "halon container"
	desc = "A compacted ball of quick release halon firefighting gas."

/obj/effect/foam_container/gas/Smoke()
	atmos_spawn_air("n2=[50];TEMP=[200]")
	playsound(src,'sound/effects/smoke.ogg',100,1)
	qdel(src)

/datum/crafting_recipe/sprinkler
	name = "Water Sprinkler"
	result = /obj/machinery/sprinkler
	time = 35
	reqs = list(/obj/item/stack/sheet/metal = 1,
				  /obj/item/stack/sheet/glass = 1,
				  /obj/item/reagent_containers/glass/beaker = 1)
	tools = list(/obj/item/weldingtool,
		         /obj/item/wrench)
	category = CAT_MISC