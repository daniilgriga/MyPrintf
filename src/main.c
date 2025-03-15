#include <stdio.h>

extern int MyPrintf (const char* a, ...);

int main (void)
{
    fprintf (stderr, "Call MyPrintf >>> ");

    MyPrintf ("\nin arg:  10: <%b>\n",  10);
    MyPrintf ("in arg: -10: <%b>", -10);

    fprintf (stderr, " <<< End of call\n");

    return 0;
}
