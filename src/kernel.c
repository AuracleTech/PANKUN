#include "print.h"

void main()
{
    print_clear();
    print_set_color(PRINT_COLOR_GREEN, PRINT_COLOR_BLACK);
    print_str("You've been served!");
    for (;;)
        ;
    return;
}