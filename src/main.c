#include <stdio.h>

#include "color_print.h"

extern int MyPrintf (const char* a, ...);

int main (void)
{
    fprintf (stderr, "Call MyPrintf >>> ");

    int result = MyPrintf ("\n" "CHECK: <%d> <%d> <%d>" "\n", 1, 2, 543);
    if (result == 666)
        fprintf (stderr,"\n" RED_TEXT(" Error in ") PURPLE_TEXT("%s: %d") "\n", __FILE__, __LINE__ - 2);

    fprintf (stderr, " <<< End of call \n");

    fprintf (stderr, " <<<  %%o:  10 = %o\n",  10);
    fprintf (stderr, " <<<  %%o: -10 = %o\n", -10);

    return 0;
}
