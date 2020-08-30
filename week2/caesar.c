#include <stdio.h>
#include <cs50.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, string argv[])
{

    // Checks command line argument
    if (argc == 2 && isdigit(*argv[1]))
    {
        // Prompts for input and converts to int
        int key = atoi(argv[1]);
        string s = get_string("plaintext:");
        printf("ciphertext:");
        // Iterates through text letter by letter
        for (int i = 0, n = strlen(s); i < n; i++)
        {
            // Checks if lowercase between z
            if (s[i] >= 'a' && s[i] <= 'z')
            {
                // Prints out lowercase
                printf("%c", (((s[i] - 'a') + key) % 26) + 'a');
            }
            // Checks if uppercase between A and Z
            else if (s[i] >= 'A' && s[i] <= 'Z')
            {
                // Prints out uppercase
                printf("%c", (((s[i] - 'A') + key) % 26) + 'A');
            }
            else
            {
                printf("%c", s[i]);
            }
        }
        printf("\n");
        return 0;
    }
    else
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }
}
