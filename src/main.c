#include <stdio.h>

#include "color_print.h"

extern int MyPrintf (const char* a, ...);

int main (void)
{
    int result = MyPrintf ("\n" "greeting = '%s'." "\n -3803 %%d: '%d'\n -3803 %%b: '%b'\n -3803 %%o: '%o'\n -3803 %%x: '%x'" "\n",
                                "sup man, thats your debug:", -3803, -3803, -3803, -3803);
    if (result == 666)
        fprintf (stderr, RED_TEXT(" Error in ") PURPLE_TEXT("%s: %d") "\n", __FILE__, __LINE__ - 3);

    fprintf (stderr, "REAL PRINTF:\n -3803 %%d: '%d'\n -3803 %%b: '%b'\n -3803 %%o: '%o'\n -3803 %%x: '%x'" "\n", -3803, -3803, -3803, -3803);
    return 0;
}
