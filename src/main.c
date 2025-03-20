#include <stdio.h>

#include "color_print.h"

extern int MyPrintf (const char* a, ...);

int main (void)
{
    int result = MyPrintf ("\n" "greeting = '%s'." "\n 123 %%d: '%d'\n 123 %%b: '%b'\n 123 %%o: '%o'\n 123 %%x: '%x'" "\n",
                                "sup man, thats your debug:", 123, 123, 123, 123);
    if (result == 666)
        fprintf (stderr,RED_TEXT(" Error in ") PURPLE_TEXT("%s: %d") "\n", __FILE__, __LINE__ - 2);

    fprintf (stderr, "REAL PRINTF:\n 123 %%d: '%d'\n 123 %%b: '%b'\n 123 %%o: '%o'\n 123 %%x: '%x'" "\n", 123, 123, 123, 123);
    return 0;
}
