/* menu.h - show menu */

#ifndef __SHOWMENU_H__
#define __SHOWMENU_H__

// init menuound viewer
void menuInit(int active);

// menu is the active window
void menuSetActive();

// menu no more is the active window
void menuSetInactive();

// draw menuound-window if needed
void menuDraw();

// forced drawing of menuound-window
void menuForceDraw();

// act on keypress
void menuProcessKey(int key);

// close menuound-viewer
void menuDone();

extern WINDOW *inputWin;

#endif

