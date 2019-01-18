/client/cmd_admin_rejuvenate(mob/living/M in GLOB.mob_list)
	. = ..()
	M.unascend_animation()
	M.visible_message("<span class='warning bold'>[M] was healed by divine intervention!</span>")

/client/proc/cmd_admin_mod_player_dosh(client/C in GLOB.clients, var/operation)
	set category = "Special Verbs"
	set name = "Modify OOC Money"

	if(!check_rights(R_ADMIN))
		return

	var/msg = ""
	var/log_text = ""

	if(operation == "zero")
		log_text = "Set to 0"
		SSpersistence.player_dosh -= C.ckey
	else
		var/prompt = "Please enter the amount of reputation to [operation]:"

		if(operation == "set")
			prompt = "Please enter the new reputation value:"

		msg = input("Message:", prompt) as num

		if (!msg)
			return

		var/DOSH_EARNED_MAXIMUM = CONFIG_GET(number/dosh_earned_maximum)
		var/DOSH_EARNED_MINIMUM = CONFIG_GET(number/dosh_earned_minimum)

		if(operation == "set")
			log_text = "Set to [num2text(msg)]"
			SSpersistence.player_dosh[C.ckey] = max(DOSH_EARNED_MINIMUM, min(msg, DOSH_EARNED_MAXIMUM))
		else if(operation == "add")
			log_text = "Added [num2text(msg)]"
			SSpersistence.player_dosh[C.ckey] = min(SSpersistence.player_dosh[C.ckey]+msg, DOSH_EARNED_MAXIMUM)
		else if(operation == "subtract")
			log_text = "Subtracted [num2text(msg)]"
			SSpersistence.player_dosh[C.ckey] = max(SSpersistence.player_dosh[C.ckey]-msg, 0)
		else
			to_chat(src, "Invalid operation for OOC money modification: [operation] by user [key_name(usr)]")
			return

		if(SSpersistence.player_dosh[C.ckey] <= 0)
			SSpersistence.player_dosh -= C.ckey

	log_admin("[key_name(usr)]: Modified [key_name(C)]'s OOC Money [log_text]")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)]: Modified [key_name(C)]'s OOC Money ([log_text])</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Modify OOC Money") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


