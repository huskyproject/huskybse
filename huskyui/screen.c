/* screen.c - screen routines */
#include <ncurses.h>
#include "screen.h"

/* initialize screen */
void scrInit()
{
  // init ncurses
  initscr();
  clear();
  noecho();
  nonl();
}

void scrDone()
{
  mvcur(0, COLS - 1, LINES - 1, 0);
  endwin();
}


