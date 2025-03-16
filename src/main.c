#include <stdio.h>

extern int MyPrintf (const char* a, ...);

int main (void)
{
    fprintf (stderr, "Call MyPrintf >>> ");

    MyPrintf ("\nin arg:  10: <%b>\n",  34);
    MyPrintf ("in arg: -10: <%b>", -34);

    fprintf (stderr, " <<< End of call\n");

    return 0;
}
