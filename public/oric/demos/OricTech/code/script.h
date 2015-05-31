


#define SCROLLER_END								0
#define SCROLLER_NOTHING							1

#define SCROLLER_TOP_ACTIVE							2	// ,active
#define SCROLLER_TOP_SET_X  						3	// ,x
#define SCROLLER_TOP_SET_DX  						4	// ,dx

#define SCROLLER_BOTTOM_ACTIVE 						5	// ,active
#define SCROLLER_BOTTOM_SET_X  						6	// ,x
#define SCROLLER_BOTTOM_SET_DX  					7	// ,dx

#define SCROLLER_OVERLAY_SET_Y 						8	// ,x
#define SCROLLER_OVERLAY_SET_LINEINC				9	// ,dx
#define SCROLLER_OVERLAY_SET_DIRECTION				10	// ,x

#define SetOverlayPosition(y)    SCROLLER_OVERLAY_SET_Y,<(_BufferInverseVideo+y*INVERSE_WIDTH),>(_BufferInverseVideo+y*INVERSE_WIDTH)

