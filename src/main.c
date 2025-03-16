#include <stdio.h>

extern int MyPrintf (const char* a, ...);

int main (void)
{
    fprintf (stderr, "Call MyPrintf >>> ");

    MyPrintf ("\n" "CHECK: <%d> <%b> <%b> <%d> <%b> <%b> <%d>" "\n", 1, 2, 3, 4, 5, 6, 7);

    fprintf (stderr, " <<< End of call\n");

    return 0;
}
