/* showlog.h - show logfile */

#ifndef __SHOWLOG_H__
#define __SHOWLOG_H__

// init log-viewer
void logInit(int active);

// log-window is the active window
void logSetActive();

// log-window no more is the active window
void logSetInactive();

// draw log-window if needed
void logDraw();

// forced drawing of log-window
void logForceDraw();

// act on keypress
void logProcessKey(int key);

// close log-viewer
void logDone();

#endif
