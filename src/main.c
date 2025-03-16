#include <stdio.h>

extern int MyPrintf (const char* a, ...);

int main (void)
{
    fprintf (stderr, "Call MyPrintf >>> ");

    MyPrintf ("\n" "CHECK: <%d> <%b> <%k>" "\n", 1, 2, 'X');

    fprintf (stderr, " <<< End of call\n");

    return 0;
}
