
//#define SCROLLER_OFFSET 40*18*8
// does asm accept 0x vs $ ??
//#define SCROLLER_OFFSET 0x9800+32*8-0xa000
//#define SCROLLER_OFFSET 38912+33*8-40960

// define if you want double height text
#define SCROLLER_DOUBLE_HEIGHT	1


#define SCROLLER_END				0
#define SCROLLER_NOTHING			1
#define SCROLLER_SHOW_SCROLL		2	// no param
#define SCROLLER_SCROLL_SCROLL		3	// no param
//#define SCROLLER_SCREEN_UP		3	// no param
#define SCROLLER_SHOW_LOGOA13		4	// no param
#define SCROLLER_SHOW_BELETT   		5   // no param
#define SCROLLER_RESET_BOTTOM_CB			6 // callback address
#define SCROLLER_DONE                   15  // no param

#define SCROLLER_BOTTOM_TEXT            17 // text address
#define SCROLLER_SET_BOTTOM_CB			16 // callback address

#define BOING_BYTE_WIDTH 10

#define TWIN_COL  12
#define TWIN_LINE 14
#define TWIN_WIDTH 40-14-1
#define TWIN_HEIGHT 10

#define LOGOA0XB_X 16
#define LOGOA0XB_Y 110
#define LOGOA0XB_W 19
#define LOGOA0XB_H 44
