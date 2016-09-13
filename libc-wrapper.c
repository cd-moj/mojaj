/*
 *This file is part of CD-MOJ.
 *
 *CD-MOJ is free software: you can redistribute it and/or modify
 *it under the terms of the GNU General Public License as published by
 *the Free Software Foundation, either version 3 of the License, or
 *(at your option) any later version.
 *
 *Foobar is distributed in the hope that it will be useful,
 *but WITHOUT ANY WARRANTY; without even the implied warranty of
 *MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *GNU General Public License for more details.
 *
 *You should have received a copy of the GNU General Public License
 *along with CD-MOJ.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <errno.h>
#include <sched.h>

pid_t fork(void)
{
  exit(EACCES);
}

FILE * fopen(const char *filename, const char *mode)
{
  exit(EACCES);
}

FILE * fdopen(int fildes, const char *mode)
{
  exit(EACCES);
}

FILE * freopen(const char *filename, const char *mode, FILE *stream)
{
  exit(EACCES);
}

int system(const char *command)
{
  exit(EACCES);
}

FILE * popen(const char *command, const char *mode)
{
  exit(EACCES);
}

int pipe(int fildes[2])
{
  exit(EACCES);
}

int open(const char *path, int oflag, ...)
{
  exit(EACCES);
}

int execl(const char *path, const char *arg, ...)
{
  exit(EACCES);
}
int execlp(const char *file, const char *arg, ...)
{
  exit(EACCES);
}
int execv(const char *path, char *const argv[])
{
  exit(EACCES);
}
int execvp(const char *file, char *const argv[])
{
  exit(EACCES);
}
int execvpe(const char *file, char *const argv[], char *const envp[])
{
  exit(EACCES);
}

long clone(unsigned long flags, void *child_stack, void *ptid, void *ctid, struct pt_regs *regs)
{
  exit(EACCES);
}
