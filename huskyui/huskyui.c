/*
 * huskyui.c
 */

#include <ncurses.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include "screen.h"
#include "sock.h"
#include "showlog.h"
#include "showoutb.h"
#include "menu.h"
#include "cfg.h"

typedef enum _eWindow { logwindow, outbwindow, menuwindow } eWindow;


/* global vars */
int do_exit = 0;
eWindow activeWindow;


int main(int argc, char *argv[])
{
  int c;

  cfgInit();
  scrInit();
  logInit(0);
  outbInit(0);
  menuInit(1);
  activeWindow = menuwindow;

  while (!do_exit)
  {
    c = wgetch(inputWin);

    if (c == ERR) usleep(100000);
    else
    {
      switch (c)
      {
      case 27:
        do_exit = 1;
	break;

      case 'q':
        do_exit = 1;
	break;

      case 9:
	switch (activeWindow)
	{
	case logwindow:
	  {
	    logSetInactive();
	    outbSetActive();
	    activeWindow = outbwindow;
	  }
	  break;

	case outbwindow:
	  {
	    outbSetInactive();
	    menuSetActive();
	    activeWindow = menuwindow;
	  }
	  break;

	case menuwindow:
	  {
	    menuSetInactive();
	    logSetActive();
	    activeWindow = logwindow;
	  }
	  break;
	}

      default:
	switch (activeWindow)
	{
	case logwindow:
	  logProcessKey(c);
	  break;

	case outbwindow:
	  outbProcessKey(c);
	  break;

	case menuwindow:
	  menuProcessKey(c);
	  break;
	}
      }
    }

    logDraw();
    outbDraw();
    menuDraw();
  }

  menuDone();
  outbDone();
  logDone();
  scrDone();
  cfgDone();

  return 0;
}

