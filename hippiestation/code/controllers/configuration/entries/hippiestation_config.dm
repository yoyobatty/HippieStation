/datum/config_entry/flag/mentors_mobname_only

/datum/config_entry/string/internet_address_to_use

/datum/config_entry/string/token_generator

/datum/config_entry/string/token_consumer

/datum/config_entry/string/tts_api

/datum/config_entry/flag/mentor_legacy_system	//Defines whether the server uses the legacy mentor system with mentors.txt or the SQL system
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/allow_vote_shuttlecall	// allow shuttle to be called via vote

/datum/config_entry/flag/enable_tts

/datum/config_entry/flag/use_player_dosh // see game_options.txt for details


/datum/config_entry/number/dosh_earned_maximum
	config_entry_value = 5000
	min_val = 0

/datum/config_entry/number/dosh_earned_minimum
	config_entry_value = 1
	min_val = 0

/datum/config_entry/number/dosh_tax_rate
	config_entry_value = 20
	min_val = 1
