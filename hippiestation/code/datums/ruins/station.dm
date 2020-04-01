// Hey! Listen! Update \config\maintruinblacklist.txt with your new ruins!
/datum/map_template/maint
	name = "Maint Basic"
	var/prefix = "_maps/RandomRuins/StationRuins/"
	var/suffix = "maint_basic.dmm"

/datum/map_template/maint/New()
	mappath = prefix + suffix
	..(path = mappath)

/datum/map_template/maint/threebythree
	name = "Maint 3x3"

/datum/map_template/maint/threebythree/New()
	suffix = pick("maint_3x3_basic", "maint_3x3_jani")
	..()
