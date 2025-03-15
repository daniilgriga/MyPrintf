#include <stdio.h>

extern int MyPrintf (const char* a, ...);

int main (void)
{
    fprintf (stderr, "Call MyPrintf >>> ");

    MyPrintf ("<WASSSUP>: <%d>, <%d>, <%d>, <%d>, <%d>, <%d>, <%d>", -12, 34, -56, 78, -90, 12, -34);

    fprintf (stderr, " <<< End of call\n");

    return 0;
}
