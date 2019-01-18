/datum/controller/subsystem/ticker
	var/login_music_name					// hippie - song name displayed when title theme plays

/datum/controller/subsystem/ticker/Initialize(timeofday)
	login_music_name = pop(splittext(login_music, "/")) // title name will be last element of the list
	return ..()

/datum/controller/subsystem/ticker/Shutdown()
	gather_newscaster() //called here so we ensure the log is created even upon admin reboot
	save_admin_data()
	update_everything_flag_in_db()
	if(!round_end_sound)
		round_end_sound = pick(\
		'sound/roundend/newroundsexy.ogg',
		'sound/roundend/apcdestroyed.ogg',
		'sound/roundend/bangindonk.ogg',
		'sound/roundend/leavingtg.ogg',
		'sound/roundend/its_only_game.ogg',
		'sound/roundend/yeehaw.ogg',
		'hippiestation/sound/roundend/disappointed.ogg',
		'hippiestation/sound/roundend/enjoyedyourchaos.ogg',
		'hippiestation/sound/roundend/yamakemesick.ogg',
		'hippiestation/sound/roundend/trapsaregay.ogg',
		'hippiestation/sound/roundend/gayfrogs.ogg',
		'hippiestation/sound/roundend/nitrogen.ogg',
		'hippiestation/sound/roundend/henderson.ogg',
		'hippiestation/sound/roundend/gameoverinsertfourcoinstoplayagain.ogg',
		'hippiestation/sound/roundend/reasonsunknown.ogg',
		'hippiestation/sound/roundend/welcomehomejosh.ogg'\
		)

	SEND_SOUND(world, sound(round_end_sound))
	text2file(login_music, "data/last_round_lobby_music.txt")


/datum/controller/subsystem/ticker/show_roundend_report(client/C, previous = FALSE)
	var/datum/browser/roundend_report = new(C, "roundend")
	roundend_report.width = 800
	roundend_report.height = 600
	var/content
	var/filename = C.roundend_report_file()
	if(!previous)
		var/list/report_parts = list(personal_report(C), tax_report(C), GLOB.common_report)
		content = report_parts.Join()
		C.verbs -= /client/proc/show_previous_roundend_report
		fdel(filename)
		text2file(content, filename)
	else
		content = file2text(filename)
	roundend_report.set_content(content)
	roundend_report.stylesheets = list()
	roundend_report.add_stylesheet("roundend", 'html/browser/roundend.css')
	roundend_report.open(FALSE)

/datum/controller/subsystem/ticker/proc/tax_report(client/C)
	var/DOSH_TAX_RATE = CONFIG_GET(number/dosh_tax_rate)
	var/mob/M = C.mob
	var/T4 = (M.job.paycheck * (100 - DOSH_TAX_RATE))
	if(M.mind && !isnewplayer(M))
		return "Income report: [T4] in net income at a tax rate of [DOSH_TAX_RATE]%.</span>"
	SSpersistence.player_dosh_change[C.ckey] += T4

