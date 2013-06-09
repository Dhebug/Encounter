// --------------------------------------
//   Profile
// --------------------------------------
// (c) 2009-2010
// Mickael Pointier and Jonathan Bristow
//
// This code is provided as-is.
// I do not assume any responsability
// concerning the fact this is a bug-free
// software !!!
// Except that, you can use this example
// without any limitation !
// If you manage to do something with that
// please, contact me :)
// --------------------------------------
// --------------------------------------
// For more information, please contact me
// on internet:
// e-mail: mike@defence-force.org
// URL: http://www.defence-force.org
// --------------------------------------
// Note: This text was typed with a Win32
// editor. So perhaps the text will not be
// displayed correctly with other OS.

#include "lib.h"
#include "profile.h"


void Test_20000();
void TestAsm();


void TestSpeed()
{
	PROFILE_ENTER(ROUTINE_TEST20000);
	Test_20000();
	PROFILE_LEAVE(ROUTINE_TEST20000);
	
	PROFILE_ENTER(ROUTINE_TEST20000);
	Test_20000();
	PROFILE_LEAVE(ROUTINE_TEST20000);
	
	PROFILE_ENTER(ROUTINE_TEST20000);
	Test_20000();
	PROFILE_LEAVE(ROUTINE_TEST20000);	
}


void DoSomething()
{
	static int x=1;
	static int y=1;
	static int r=1;
	
	PROFILE_ENTER(ROUTINE_DOSOMETHING);
	
	if (r<99)
	{
		curset(x,y,1);
		circle(r,2);
		
		r+=1;
		x+=1;
		y+=1;
	}

	PROFILE_LEAVE(ROUTINE_DOSOMETHING);
}


void RandomSubroutine()
{
	PROFILE_ENTER(ROUTINE_SUBROUTINE);
	PROFILE_LEAVE(ROUTINE_SUBROUTINE);
}


void DoSomethingElse()
{
	static int x=238;
	static int y=1;
	static int r=1;
	
	PROFILE_ENTER(ROUTINE_DOSOMETHINGELSE);
	
	if (r<99)
	{
		RandomSubroutine();
		curset(x,y,1);
		RandomSubroutine();
		circle(r,1);
		RandomSubroutine();
		
		r+=1;
		x-=1;
		y+=1;
	}
	PROFILE_LEAVE(ROUTINE_DOSOMETHINGELSE);
}


void main()
{
	printf("If you see this message, you probably need to enable the PRINTER output when booting - F3 in Euphoric -\nResults are in PROFILE.TXT");
	ProfilerInitialize();

	hires();
	
	while (1)
	{
		ProfilerNextFrame();
		
		PROFILE_ENTER(ROUTINE_GLOBAL);
		TestSpeed();
		TestAsm();
		DoSomething();
		DoSomethingElse();
		PROFILE_LEAVE(ROUTINE_GLOBAL);
		
		ProfilerDisplay();
	}
	
	ProfilerTerminate();

	printf("Done\n");	
}


