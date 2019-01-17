#define FILE_DOSH "data/PlayerDosh.json"

/datum/controller/subsystem/persistence
	var/list/player_dosh = list()
	var/list/player_dosh_change = list()

/datum/controller/subsystem/persistence/Initialize()
	. = ..()
	if(CONFIG_GET(flag/use_player_dosh))
		LoadDosh()

/datum/controller/subsystem/persistence/proc/LoadDosh()
	var/json = file2text(FILE_DOSH)
	if(!json)
		var/json_file = file(FILE_DOSH)
		if(!fexists(json_file))
			WARNING("Failed to load player dosh. File likely corrupt.")
			return
		return
	player_dosh = json_decode(json)

/datum/controller/subsystem/persistence/CollectData()
	..()
	if(CONFIG_GET(flag/use_player_dosh))
		CollectDosh()

/datum/controller/subsystem/persistence/proc/CollectDosh()
	var/DOSH_EARNED_MAXIMUM = CONFIG_GET(number/dosh_earned_maximum)
	var/DOSH_EARNED_MINIMUM = CONFIG_GET(number/dosh_earned_minimum)

	for(var/p_ckey in player_dosh_change)
		player_dosh[p_ckey] = max(DOSH_EARNED_MINIMUM, min(player_dosh[p_ckey]+player_dosh_change[p_ckey], DOSH_EARNED_MAXIMUM))

	player_dosh_change = list()

	fdel(FILE_DOSH)
	text2file(json_encode(player_dosh), FILE_DOSH)

