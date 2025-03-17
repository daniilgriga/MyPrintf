#include <stdio.h>

#include "color_print.h"

extern int MyPrintf (const char* a, ...);

int main (void)
{
    int result = MyPrintf ("\n" "'%d' in binary: '%b', in octal '%o'" "\n", 10, 10, 10);
    if (result == 666)
        fprintf (stderr,RED_TEXT(" Error in ") PURPLE_TEXT("%s: %d") "\n", __FILE__, __LINE__ - 2);

    //fprintf (stderr, "Call MyPrintf >>> ");

    //int result = MyPrintf ("\n" "     MyPrintf >>>: 45 in OCT = <%o> ||| -45 in OCT = <%o>", 45, -45);
    //if (result == 666)
    //    fprintf (stderr,"\n" RED_TEXT(" Error in ") PURPLE_TEXT("%s: %d") "\n", __FILE__, __LINE__ - 2);

    //fprintf (stderr, " <<< End of call \n");

    //fprintf (stderr, "Real printf() >>>: 45 in OCT = <%o> ||| -45 in OCT = <%o>\n",  45, -45);

    //int result_2 = MyPrintf ("\n" " STD CHECKS: 134 d = <%d> ||| 134 b = <%b> ||| 134 c = <%c>" "\n", 134, 134, 134);
    //if (result_2 == 666)
    //    fprintf (stderr,"\n" RED_TEXT(" Error in ") PURPLE_TEXT("%s: %d") "\n", __FILE__, __LINE__ - 2);

    return 0;
}
