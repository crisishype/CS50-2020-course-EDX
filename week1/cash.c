#include <cs50.h>
#include <stdio.h>
#include <math.h>

int main(void)
{
    // Creates a float and reprompts if not correct
    float dollars;
    do
    {
        dollars = get_float("Change:");
    }
    while (dollars <= .00);
    {
        // Creates an int and converts the float and change to whole numbers
        int cents = round(dollars * 100);
        int coins = 0;
        for (int i = 0; cents >= 25; i++)
        {
            coins++;
            cents -= 25;
        }
        for (int j = 0; cents >= 10; j++)
        {
            coins++;
            cents -= 10;
        }
        for (int k = 0; cents >= 5; k++)
        {
            coins++;
            cents -= 5;
        }
        for (int l = 0;  cents >= 1; l++)
        {
            coins++;
            cents -= 1;
        }
        printf("%i\n", coins);
    }
}

