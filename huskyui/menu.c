/* menu.c - show menu */
#include <stdlib.h>
#include <ncurses.h>
#include <unistd.h>
#include "screen.h"
#include "cfg.h"
#include "showlog.h"
#include "showoutb.h"
#include "menu.h"

WINDOW *menuWin, *menuWinBoxed;
WINDOW *inputWin;
int menuIsActive;

void menuInit(int active)
{
  menuWinBoxed = newwin((LINES - 1) / 3, COLS - 1, ((LINES - 1) / 3) * 2, 0);
  menuWin = newwin(((LINES - 1) / 3) - 2, COLS - 5,
		   (((LINES - 1) / 3) * 2) + 1, 2);
  inputWin = menuWin;
  nodelay(inputWin, TRUE);
  keypad(inputWin, TRUE);

  leaveok(menuWin, TRUE);
  scrollok(menuWin, TRUE);

  menuIsActive = active;
  menuForceDraw();
}

void menuSetActive()
{
  menuIsActive = 1;
  menuForceDraw();
}

void menuSetInactive()
{
  menuIsActive = 0;
  menuForceDraw();
}

void menuDraw()
{
//  int menuUpdated = 0;
  
//  if (menuUpdated != 0) menuForceDraw();
}

void menuForceDraw()
{
  if (menuIsActive == 0)
  {
    wborder(menuWinBoxed, ACS_VLINE, ACS_VLINE, ACS_HLINE, ACS_HLINE,
	    ACS_ULCORNER, ACS_URCORNER, ACS_LLCORNER, ACS_LRCORNER);
  }
  else
  {
    wborder(menuWinBoxed, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK,
	    ACS_BLOCK, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK);
  }
  mvwprintw(menuWinBoxed, 0, (COLS - 6) / 2, " menu ");

  wmove(menuWin, 0, 0);

  wprintw(menuWin,
	  "<1> Poll boss\n"
	  "<2> Read mails\n"
	  "<q> quit\n"
	  "\n"
	  "Press <?> for help\n");

  wrefresh(menuWinBoxed);
  wrefresh(menuWin);
}

void menuPollBoss()
{
  int rc;
  char *cmdline;
  char *addr;
  char rfcAddr[30];

  if (cfg.pollCmd != NULL)
  {
    if (fork() == 0) // do it in background
    {
      addr = aka2str(cfg.bossAddr);
      sprintf(rfcAddr, "f%d.n%d.z%d", cfg.bossAddr.node, cfg.bossAddr.net,
	      cfg.bossAddr.zone);
      cmdline = malloc(strlen(cfg.pollCmd)+strlen(addr)+strlen(rfcAddr)+1);
      sprintf(cmdline, cfg.pollCmd, addr, rfcAddr);
      rc = system(cmdline);
      free(cmdline);

      exit(0);
    }

    clearok(menuWinBoxed, TRUE);
    menuForceDraw();
    logForceDraw();
    outbForceDraw();
  }
}

void menuReadMails()
{
  int rc;

  if (cfg.mailEditor != NULL)
  {
    menuDone();
    outbDone();
    logDone();
    scrDone();

    rc = system(cfg.mailEditor);

    scrInit();
    logInit(0);
    outbInit(0);
    menuInit(1);
  }
}

void menuShowHelp()
{
  WINDOW *helpWinBoxed, *helpWin;

  helpWinBoxed = newwin(LINES - 1, COLS - 1, 0, 0);
  helpWin = newwin(LINES - 3, COLS - 5, 1, 2);

  wborder(helpWinBoxed, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK,
	  ACS_BLOCK, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK);
  mvwprintw(helpWinBoxed, 0, (COLS - 11) / 2, " menu help ");

  mvwprintw(helpWin, 0, 0,
	    "\n"
	    "<1>           poll your boss node for mails\n"
	    "<2>           read and write mails and export them\n"
	    "\n"
	    "<?>           help (this screen)\n"
	    "<Tab>         cycle through windows\n"
	    "\n"
	    "<q>           quit\n"
	    "\n"
	    "Press any key to continue\n");

  wrefresh(helpWinBoxed);
  wrefresh(helpWin);

  wgetch(helpWin);

  delwin(helpWin);
  delwin(helpWinBoxed);

  touchwin(stdscr); wrefresh(stdscr);
  logForceDraw();
  outbForceDraw();
  menuForceDraw();
}

void menuProcessKey(int key)
{
  switch (key)
  {
  case '1':
    menuPollBoss();
    break;

  case '2':
    menuReadMails();
    break;

  case '?':
    menuShowHelp();
    break;
  }
}

void menuDone()
{
  delwin(menuWin);
  delwin(menuWinBoxed);
}

