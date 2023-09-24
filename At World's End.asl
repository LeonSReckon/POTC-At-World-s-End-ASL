// Pirates of the Caribbean At Worlds End AutoSplitter Version 2.0.0 6/9/2023
// Requires 12 Splits
// Pointers, Script, Updates, Remodifications <by> ||LeonSReckon||

state("At Worlds End")
{
	byte  Load   : 0x3D5C78;                                          // 1 On Loading screens where there's a cumpass at the bottom right of the screen, 0 Everywhere else
	byte  lvl    : 0x3D8B64;                                          // Changes from 51 to 62 in the order of the levels
	float HP     : 0x5DAF8, 0x0;                                      // Player's HP
	float Boss   : 0x3CF900, 0x8, 0x8, 0x0, 0x58, 0xDC8, 0x10, 0x398; // Opponent's HP in duels
}

startup
{

	settings.Add("SpeedRun", true, "SpeedRun");
	settings.CurrentDefaultParent = "SpeedRun";
	settings.Add("Full Game", true, "Full Game");
	settings.Add("IL", false, "Individual Levels");
	settings.CurrentDefaultParent = null;

	settings.Add("Main", true, "Main Game Categories");
	settings.CurrentDefaultParent = "Main";
	settings.Add("New Story", true, "New Story");
	settings.Add("Replay Story", false, "Replay Story");
	settings.CurrentDefaultParent = null;
	
    // vars
    vars.Loads_count     = 0;
	vars.completedSplits = new List<byte>()
	{151};
	vars.LvlStorage      = new List<byte>()
	{51,52,53,54,55,56,57,58,59,60,61,62};
	
    // actions
    Action reset_vars = () => {
    vars.Loads_count     = 0;
    };
	
	vars.reset_vars = reset_vars;

}

init
{
    vars.Loads_count     = 0;
	vars.completedSplits = new List<byte>()
	{151};
}

start
{
	return vars.LvlStorage.Contains(current.lvl) && old.Load == 1 && current.Load == 0;
}

split
{
	if(settings ["New Story"]){
	    if(current.lvl != old.lvl && current.lvl != 151){
	        return true;
        }
    }
	
	if(settings ["Replay Story"]){
		if(current.lvl != old.lvl && !vars.completedSplits.Contains(current.lvl)){
		    {
				vars.completedSplits.Add(current.lvl);
				return true;
		    }
		}
    }
	
	if(settings ["Full Game"]){
	// Story final split
	    if(old.lvl == 62)
        {
            // update Loads_count
            if(current.Load == 1 && old.Load == 0 && current.HP > 0) vars.Loads_count++;

            // reset Loads_count
            if(current.lvl == 151 && old.lvl < 151) vars.Loads_count = 0;
		
            // split
            if(vars.Loads_count == 4) { vars.reset_vars(); return true; }
        }
	}
	
	if(settings ["IL"]){
	    if(current.lvl == 151 && old.lvl != 151){
	        return true;
        }
    }
}

isLoading
{
	return current.Load == 1;
}

onReset
{
    vars.reset_vars();
}

reset
{
	return old.lvl == 151 && current.lvl == 51;
}
