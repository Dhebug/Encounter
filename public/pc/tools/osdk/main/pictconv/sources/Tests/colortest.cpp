
#include "../../../../../../shared_libraries/unittestcpp/v1.4/src/UnitTest++.h"

#include "shifter_color.h"
#include "getpixel.h"


TEST(ColorTest)
{
	// Test the STE bit conversion tables
	CHECK_EQUAL( 0,ShifterColor::ValueToSte(0));
	CHECK_EQUAL( 8,ShifterColor::ValueToSte(1));
	CHECK_EQUAL( 1,ShifterColor::ValueToSte(2));
	CHECK_EQUAL( 9,ShifterColor::ValueToSte(3));
	CHECK_EQUAL( 2,ShifterColor::ValueToSte(4));
	CHECK_EQUAL(10,ShifterColor::ValueToSte(5));
	CHECK_EQUAL( 3,ShifterColor::ValueToSte(6));
	CHECK_EQUAL(11,ShifterColor::ValueToSte(7));
	CHECK_EQUAL( 4,ShifterColor::ValueToSte(8));
	CHECK_EQUAL(12,ShifterColor::ValueToSte(9));
	CHECK_EQUAL( 5,ShifterColor::ValueToSte(10));
	CHECK_EQUAL(13,ShifterColor::ValueToSte(11));
	CHECK_EQUAL( 6,ShifterColor::ValueToSte(12));
	CHECK_EQUAL(14,ShifterColor::ValueToSte(13));
	CHECK_EQUAL( 7,ShifterColor::ValueToSte(14));
	CHECK_EQUAL(15,ShifterColor::ValueToSte(15));

	// Test the reversed STE bit conversion tables
	CHECK_EQUAL( 0,ShifterColor::ValueFromSte( 0));
	CHECK_EQUAL( 1,ShifterColor::ValueFromSte( 8));
	CHECK_EQUAL( 2,ShifterColor::ValueFromSte( 1));
	CHECK_EQUAL( 3,ShifterColor::ValueFromSte( 9));
	CHECK_EQUAL( 4,ShifterColor::ValueFromSte( 2));
	CHECK_EQUAL( 5,ShifterColor::ValueFromSte(10));
	CHECK_EQUAL( 6,ShifterColor::ValueFromSte( 3));
	CHECK_EQUAL( 7,ShifterColor::ValueFromSte(11));
	CHECK_EQUAL( 8,ShifterColor::ValueFromSte( 4));
	CHECK_EQUAL( 9,ShifterColor::ValueFromSte(12));
	CHECK_EQUAL(10,ShifterColor::ValueFromSte( 5));
	CHECK_EQUAL(11,ShifterColor::ValueFromSte(13));
	CHECK_EQUAL(12,ShifterColor::ValueFromSte( 6));
	CHECK_EQUAL(13,ShifterColor::ValueFromSte(14));
	CHECK_EQUAL(14,ShifterColor::ValueFromSte( 7));
	CHECK_EQUAL(15,ShifterColor::ValueFromSte(15));

	// Test the big endian conversion
	CHECK_EQUAL(0x0000,ShifterColor(RgbColor(0,0,0)).GetBigEndianValue());
	CHECK_EQUAL(0x000F,ShifterColor(RgbColor(255,0,0)).GetBigEndianValue());
	CHECK_EQUAL(0xF000,ShifterColor(RgbColor(0,255,0)).GetBigEndianValue());
	CHECK_EQUAL(0x0F00,ShifterColor(RgbColor(0,0,255)).GetBigEndianValue());
	CHECK_EQUAL(0xFF0F,ShifterColor(RgbColor(255,255,255)).GetBigEndianValue());

	// Test the RGB conversion
	CHECK(RgbColor(0,0,0)==ShifterColor(RgbColor(0,0,0)).GetRgb());
	CHECK(RgbColor(255,0,0)==ShifterColor(RgbColor(255,0,0)).GetRgb());
	CHECK(RgbColor(0,255,0)==ShifterColor(RgbColor(0,255,0)).GetRgb());
	CHECK(RgbColor(0,0,255)==ShifterColor(RgbColor(0,0,255)).GetRgb());
	CHECK(RgbColor(255,255,255)==ShifterColor(RgbColor(255,255,255)).GetRgb());

	// Test the error computation
	CHECK_EQUAL(  0,ShifterColor(RgbColor(0,0,0)).ComputeDifference(ShifterColor(RgbColor(0,0,0))));
	CHECK_EQUAL(  0,ShifterColor(RgbColor(255,0,0)).ComputeDifference(ShifterColor(RgbColor(255,0,0))));
	CHECK_EQUAL(  0,ShifterColor(RgbColor(255,255,255)).ComputeDifference(ShifterColor(RgbColor(255,255,255))));
	CHECK_EQUAL( 49,ShifterColor(RgbColor(128,0,0)).ComputeDifference(ShifterColor(RgbColor(0,0,0))));
	CHECK_EQUAL(675,ShifterColor(RgbColor(255,255,255)).ComputeDifference(ShifterColor(RgbColor(0,0,0))));

	// Test the RGB color operators
	CHECK(RgbColor(0,0,0)==RgbColor(0,0,0));
	CHECK(RgbColor(255,0,0)==RgbColor(255,0,0));
	CHECK(RgbColor(0,255,0)==RgbColor(0,255,0));
	CHECK(RgbColor(0,0,255)==RgbColor(0,0,255));
	CHECK(RgbColor(255,255,255)==RgbColor(255,255,255));

	CHECK(RgbColor(0,0,0)!=RgbColor(1,0,0));
	CHECK(RgbColor(255,0,0)!=RgbColor(23,0,0));
	CHECK(RgbColor(48,0,0)!=RgbColor(48,1,0));
}

  
