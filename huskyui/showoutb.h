/* showoutb.h - outbound viewer */

#ifndef __SHOWOUTB_H__
#define __SHOWOUTB_H__

// init outbound viewer
void outbInit(int active);

// outbound-window is the active window
void outbSetActive();

// outbound-window no more is the active window
void outbSetInactive();

// draw outbound-window if needed
void outbDraw();

// forced drawing of outbound-window
void outbForceDraw();

// act on keypress
void outbProcessKey(int key);

// close outbound-viewer
void outbDone();

#endif

