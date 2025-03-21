#include <stdio.h>

#include "color_print.h"

extern int MyPrintf (const char* a, ...);

int main (void)
{
    int result = MyPrintf ("\n" "greeting = '%s'." "\n -765 %%d: '%d'\n  23  %%b: '%b'\n  456 %%o: '%o'\n  52  %%x: '%x'" "\n",
                                "sup man, thats your debug:", 765, 23, 456, 52);
    if (result == 666)
        fprintf (stderr, RED_TEXT(" Error in ") PURPLE_TEXT("%s: %d") "\n", __FILE__, __LINE__ - 3);

    fprintf (stderr, "REAL PRINTF:" "\n -765 %%d: '%d'\n  23  %%b: '%b'\n  456 %%o: '%o'\n  52  %%x: '%x'" "\n", 765, 23, 456, 52);
    return 0;
}
