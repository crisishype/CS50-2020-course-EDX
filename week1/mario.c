#include <cs50.h>
#include <stdio.h>

int main(void)
{
    //Creates variables for the whole program
    int input, hash, width, space;
    do
    {
        input = get_int("Height:");
    }

    //Checks if the user put in the right input
    while (input < 1 || input > 8);

    //Makes the user input print into spaces
    for (space = 0; space < input; space++)
    {
        //Prints hash for the pyramid
        for (hash = input - space - 1; hash > 0; hash--)
        {
            printf(" ");
        }
        //Prints the user input across as a width
        for (width = -1; width < space; width++)
        {
            printf("#");
        }
        printf("\n");
    }      
}

