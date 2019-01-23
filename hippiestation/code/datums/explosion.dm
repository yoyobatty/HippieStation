/datum/explosion/New(atom/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog, ignorecap, flame_range, silent, smoke)
	if(isnull(flash_range))
		flash_range = max(devastation_range,heavy_impact_range,light_impact_range,0)
	..()