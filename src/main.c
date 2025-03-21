#include <stdio.h>

#include "color_print.h"

extern int MyPrintf (const char* a, ...);

int main (void)
{
    int result = MyPrintf ("\n" "greeting = '%s'." "\n 3802 %%d: '%d'\n 3802 %%b: '%b'\n 3802 %%o: '%o'\n 3802 %%x: '%x'" "\n",
                                "sup man, thats your debug:", 3802, 3802, 3802, 3802);
    if (result == 666)
        fprintf (stderr, RED_TEXT(" Error in ") PURPLE_TEXT("%s: %d") "\n", __FILE__, __LINE__ - 3);

    fprintf (stderr, "REAL PRINTF:" "\n 3802 %%d: '%d'\n 3802 %%b: '%b'\n 3802 %%o: '%o'\n 3802 %%x: '%x'" "\n", 3802, 3802, 3802, 3802);
    return 0;
}
