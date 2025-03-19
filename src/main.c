#include <stdio.h>

#include "color_print.h"

extern int MyPrintf (const char* a, ...);

int main (void)
{
    int result = MyPrintf ("\n" "greeting = '%s'." "\n 245 %%d: '%d'\n 245 %%b: '%b'\n 245 %%o: '%o'\n 245 %%x: '%x'" "\n",
                                "sup man, thats your debug:", 245, 245, 245, 245);
    if (result == 666)
        fprintf (stderr,RED_TEXT(" Error in ") PURPLE_TEXT("%s: %d") "\n", __FILE__, __LINE__ - 2);

    fprintf (stderr, "REAL PRINTF:\n 245 %%d: '%d'\n 245 %%b: '%b'\n 245 %%o: '%o'\n 245 %%x: '%x'" "\n", 245, 245, 245, 245);
    return 0;
}
