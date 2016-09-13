#include <stdio.h>
#include <unistd.h>

using namespace std;

int main(void)
{
  pid_t t=fork();
  printf("==== %d\n",t);
  return 0;
}
