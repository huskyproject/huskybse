/* showoutb.c - outbound viewer */
#include <ncurses.h>
#include "showoutb.h"

WINDOW *outbWin, *outbWinBoxed;
int outbIsActive;

void outbInit(int active)
{
  outbWinBoxed = newwin((LINES - 1) / 3, COLS - 1, (LINES - 1) / 3, 0);
  outbWin = newwin(((LINES - 1) / 3) - 2, COLS - 5, ((LINES - 1) / 3) + 1, 2);

  leaveok(outbWin, TRUE);
  scrollok(outbWin, TRUE);

  outbIsActive = active;
  outbForceDraw();
}

void outbSetActive()
{
  outbIsActive = 1;
  outbForceDraw();
}

void outbSetInactive()
{
  outbIsActive = 0;
  outbForceDraw();
}

void outbDraw()
{
  int outbUpdated = 0;

  
  if (outbUpdated != 0) outbForceDraw();
}

void outbForceDraw()
{
  if (outbIsActive == 0)
  {
    wborder(outbWinBoxed, ACS_VLINE, ACS_VLINE, ACS_HLINE, ACS_HLINE,
	    ACS_ULCORNER, ACS_URCORNER, ACS_LLCORNER, ACS_LRCORNER);
  }
  else
  {
    wborder(outbWinBoxed, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK,
	    ACS_BLOCK, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK);
  }
  mvwprintw(outbWinBoxed, 0, (COLS - 10) / 2, " outbound ");

  mvwprintw(outbWin, 0, 0,
	  "coming soon :)\n");

  wrefresh(outbWinBoxed);
  wrefresh(outbWin);
}

void outbProcessKey(int key)
{

}

void outbDone()
{
  delwin(outbWin);
  delwin(outbWinBoxed);
}

