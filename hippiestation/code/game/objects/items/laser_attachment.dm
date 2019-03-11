/obj/item/laser_attachment
	name = "laser attachment"
	desc = "A low powered laser you attached to weapons to improve aiming"
	icon = 'icons/obj/device.dmi'
	icon_state = "pointer"
	item_state = "pen"
	var/pointer_icon_state
	var/laser_overlay
	var/on = FALSE
	var/datum/beam/laserbeam = null
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
	//update_laser(user)
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
	if(!ishuman(user) || !user)
		return
	if(!on)
		return
	laserbeam = new(user,user.client.mouseObject,time=10,beam_icon_state="ibeam_ttv",btype=/obj/effect/ebeam/l_beam)
	new /obj/effect/temp_visual/laser(user.client.mouseObject,pointer_icon_state)
	INVOKE_ASYNC(laserbeam, /datum/beam.proc/Start)

/obj/effect/ebeam/l_beam
	icon = 'icons/obj/projectiles.dmi'
	pass_flags = PASSTABLE|PASSGLASS|PASSGRILLE|LETPASSTHROW

/obj/effect/temp_visual/laser //color is white by default, set to whatever is needed
	name = "laser pointer"
	icon = 'icons/obj/projectiles.dmi'
	duration = 2

/obj/effect/temp_visual/laser/Initialize(mapload, l_icon_state)
	. = ..()
	icon_state = l_icon_state