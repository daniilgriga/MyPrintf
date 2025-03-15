#include <stdio.h>

extern int MyPrintf (const char* a, ...);

int main (void)
{
    fprintf (stderr, "Call MyPrintf >>> ");

    MyPrintf ("<WASSSUP>: %d", 52);

    fprintf (stderr, " <<< End of call\n");

    return 0;
}
