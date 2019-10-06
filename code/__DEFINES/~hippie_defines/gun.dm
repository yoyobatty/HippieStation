#define GUN_FIREMODE_SEMIAUTO "semi-auto fire mode"
#define GUN_FIREMODE_BURSTFIRE "burst-fire mode"
#define GUN_FIREMODE_AUTOMATIC "automatic fire mode"
#define GUN_FIREMODE_AUTOBURST "auto-burst-fire mode"

#define COMSIG_GUN_FIRE "gun_fire"
	#define COMPONENT_GUN_FIRED 1
#define COMSIG_GUN_AUTOFIRE "gun_autofire"
#define COMSIG_GUN_CLICKEMPTY "gun_clickempty"
#define COMSIG_GUN_FIREMODE_TOGGLE "gun_firemode_toggle"		//from /obj/item/weapon/gun/verb/toggle_firemode()
#define COMSIG_GUN_FIREDELAY_MODIFIED "gun_firedelay_modified"
#define COMSIG_GUN_BURSTDELAY_MODIFIED "gun_burstdelay_modified"
#define COMSIG_GUN_BURSTAMOUNT_MODIFIED "gun_burstamount_modified"

//Autofire component
#define AUTOFIRE_STAT_SLEEPING (1<<0) //Component is in the gun, but the gun is in a different firemode. Sleep until a compatible firemode is activated.
// VV wake_up() VV
// ^^ sleep_up() ^^
#define AUTOFIRE_STAT_IDLE (1<<1) //Compatible firemode is in the gun. Wait until it's held in the user hands.
// VV autofire_on() VV
// ^^ autofire_off() ^^
#define AUTOFIRE_STAT_ALERT	(1<<2) //Gun is active and in the user hands. Wait until user does a valid click.
// VV start_autofiring() VV
// ^^ stop_autofiring() ^^
#define AUTOFIRE_STAT_FIRING (1<<3) //Dakka-dakka-dakka.

#define COMSIG_AUTOFIRE_ONMOUSEDOWN "autofire_onmousedown"
	#define COMPONENT_AUTOFIRE_ONMOUSEDOWN_BYPASS (1<<0)
#define COMSIG_AUTOFIRE_SHOT "autofire_shot"
	#define COMPONENT_AUTOFIRE_SHOT_SUCCESS (1<<0)