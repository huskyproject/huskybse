/* showlog.c - show logfile */
#include <ncurses.h>
#include <stdlib.h>
#include <string.h>
#include "huskyui.h"
#include "cfg.h"
#include "showlog.h"
#include "showoutb.h"
#include "menu.h"

WINDOW *logWin, *logWinBoxed;
int logIsActive;
FILE *logFile;
char **logBuf;
char *logLine;
int logBufReadPos;
int logBufDispPos;
int logLineSize;
int logWinLen;

void logInit(int active)
{
  logWinLen = ((LINES - 1) / 3) - 2;
  logWinBoxed = newwin((LINES - 1) / 3, COLS - 1, 0, 0);
  logWin = newwin(logWinLen, COLS - 5, 1, 2);

  leaveok(logWin, TRUE);
  scrollok(logWin, TRUE);
  nodelay(logWin, TRUE);

  if (cfg.logName != NULL) logFile = fopen(cfg.logName, "r");
  else logFile = NULL;

  logBuf = calloc(cfg.numLogLines, sizeof(char *));
  logBufReadPos = 0;
  logBufDispPos = 0;
  logLineSize = COLS - 5;
  logLine = malloc(logLineSize);

  logIsActive = active;
  logForceDraw();
  logDraw();
}

void logSetActive()
{
  logIsActive = 1;
  logForceDraw();
}

void logSetInactive()
{
  logIsActive = 0;
  logForceDraw();
}

void logDraw()
{
  int logUpdated = 0;

  if (logFile == NULL) return;

  clearerr(logFile);
  while (feof(logFile) == 0)
  {
    // get line
    *logLine = 0;
    fgets(logLine, logLineSize, logFile);

    if (*logLine != 0)
    {
      logUpdated = 1;

      // strip LF
      while ((*logLine != 0) && (logLine[strlen(logLine) - 1] == '\n'))
	logLine[strlen(logLine) - 1] = 0;

      // copy line into buffer
      nfree(logBuf[logBufReadPos]);
      logBuf[logBufReadPos] = strdup(logLine);
      if ((logBufReadPos > logWinLen) &&
	  (logBufDispPos < (cfg.numLogLines - logWinLen)))
	logBufDispPos = logBufReadPos - logWinLen + 1;
      logBufReadPos++;

      // buffer-scroll needed?
      if (logBufReadPos == cfg.numLogLines)
      {
	int i;

	// move whole buffer 1 line up
	nfree(logBuf[0]);
	logBufReadPos--;
	for (i = 0; i < logBufReadPos; i++)
	  logBuf[i] = logBuf[i + 1];
	logBuf[logBufReadPos] = 0;
	logBufDispPos--;
      }

    }
  }

  if (logUpdated != 0) logForceDraw();
}

void logForceDraw()
{
  int i;

  if (logIsActive == 0)
  {
    wborder(logWinBoxed, ACS_VLINE, ACS_VLINE, ACS_HLINE, ACS_HLINE,
	    ACS_ULCORNER, ACS_URCORNER, ACS_LLCORNER, ACS_LRCORNER);
  }
  else
  {
    wborder(logWinBoxed, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK,
	    ACS_BLOCK, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK);
  }
  mvwprintw(logWinBoxed, 0, (COLS - 5) / 2, " log ");

  wmove(logWin, 0, 0);

  if (logFile == NULL)
  {
    wprintw(logWin, "Could not open logfile '%s'!\n", cfg.logName);
  }
  else
  {
    int maxPos = min(logBufReadPos, logBufDispPos + logWinLen - 1);

    for (i = logBufDispPos; i <= maxPos; i++)
    {
	if (logBuf[i] != NULL)
	{
	    if (i < maxPos) wprintw(logWin, "%s\n", logBuf[i]);
	    else wprintw(logWin, "%s", logBuf[i]);
	}
    }
  }

  wrefresh(logWinBoxed);
  wrefresh(logWin);
}

void logShowHelp()
{
  WINDOW *helpWinBoxed, *helpWin;

  helpWinBoxed = newwin(LINES - 1, COLS - 1, 0, 0);
  helpWin = newwin(LINES - 3, COLS - 5, 1, 2);

  wborder(helpWinBoxed, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK,
	  ACS_BLOCK, ACS_BLOCK, ACS_BLOCK, ACS_BLOCK);
  mvwprintw(helpWinBoxed, 0, (COLS - 10) / 2, " log help ");

  mvwprintw(helpWin, 0, 0,
	    "\n"
	    "<cursor up>   move up 1 line in logfile\n"
	    "<cursor down> move down 1 line\n"
	    "<page up>     move up 1 page\n"
	    "<page down>   move down 1 page\n"
	    "<home>        jump to beginning\n"
	    "<end>         jump to end\n"
	    "\n"
	    "<?>           help (this screen)\n"
	    "<Tab>         cycle through windows\n"
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

void logProcessKey(int key)
{
  switch (key)
  {
  case '?':
    logShowHelp();
    break;

  case KEY_UP:
    if (logBufDispPos > 0)
    {
      logBufDispPos--;
      logForceDraw();
      logDraw();
    }
    break;

  case KEY_DOWN:
    if (logBufDispPos < (logBufReadPos - 1))
    {
      logBufDispPos++;
      logForceDraw();
      logDraw();
    }
    break;

  case KEY_PPAGE:
    {
      if (logBufDispPos > (logWinLen - 1))
	logBufDispPos = logBufDispPos - logWinLen + 1;
      else
	logBufDispPos = 0;

      logForceDraw();
      logDraw();
    }
    break;

  case KEY_NPAGE:
    {
      if (logBufDispPos < (logBufReadPos - 2*logWinLen + 1))
	logBufDispPos = logBufDispPos + logWinLen - 1;
      else
	logBufDispPos = logBufReadPos - logWinLen;

      logForceDraw();
      logDraw();
    }
    break;

  case KEY_HOME:
    {
      logBufDispPos = 0;
      logForceDraw();
      logDraw();
    }
    break;

  case KEY_END:
    {
      logBufDispPos = logBufReadPos - logWinLen;
      logForceDraw();
      logDraw();
    }
    break;
  }
}

void logDone()
{
  int i;

  for (i = 0; i < cfg.numLogLines; i++) nfree(logBuf[i]);
  nfree(logBuf);
  nfree(logLine);
  if (logFile != NULL) fclose(logFile);
  delwin(logWin);
  delwin(logWinBoxed);
}

