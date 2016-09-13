#include <stdio.h>
#include <assert.h>

int main(void)
{
  int nums,tmp,soma=0;
  scanf("%d",&nums);
  for(int i=0;i<nums;i++)
  {
    scanf("%d",&tmp);
    soma+=tmp;
  }
  printf("%d\n",soma);
}
