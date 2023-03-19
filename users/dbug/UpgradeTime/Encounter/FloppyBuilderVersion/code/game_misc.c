

void InitializeGraphicMode()
{
	ClearTextWindow();
	poke(0xbb80+40*0,31);  // Switch to HIRES
	poke(0xa000+40*128,26);  // Switch to TEXT

	// from the old BASIC code, will fix later
	// CYAN on BLACK for the scene description
	poke(0xBB80+40*16,6);
	poke(0xBB80+40*17,6);    

	// BLUE background for the log output
	poke(0xBB80+40*18,16+4);
	poke(0xBB80+40*19,16+4);
	poke(0xBB80+40*20,16+4);
	poke(0xBB80+40*21,16+4);
	poke(0xBB80+40*22,16+4);
	poke(0xBB80+40*23,16+4);

	// BLACK background for the inventory area
	poke(0xBB80+40*24,16);
	poke(0xBB80+40*25,16);
	poke(0xBB80+40*26,16);
	poke(0xBB80+40*27,16);
}

