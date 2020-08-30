#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

int main(void)
{
    // Gets a string from the user
    string text = get_string("Text: ");
    int lettercount = 0;
    int wordcount = 1;
    int sentencecount = 0;
    
    // Counts the total length of input
    for (int i = 0; i < strlen(text); i++)
    {
        // Checks for between a and z and adds to letters
        if ((text[i] >= 'a' && text[i] <= 'z') || (text[i] >= 'A' && text[i] <= 'Z'))
        {
            lettercount++;
        }
        // Checks for spaces and adds
        else if (text[i] == ' ')
        {
            wordcount++;
        }
        // Checks for puncuation and adds to  sentences
        else if (text[i] == '.' || text[i] == '!' || text[i] == '?')
        {
            sentencecount++;
        }
    }
    // Prints out the total
    printf("letters: %i; words: %i; sentences: %i\n", lettercount, wordcount, sentencecount);
    
    // Runs the algorythm 
    float grade = 0.0588 * (100 * (float) lettercount / (float) wordcount) - 0.296 * (100 * (float) sentencecount /
                  (float) wordcount) - 15.8;
    if (grade < 16 && grade >= 0)
    {
        printf("Grade %i\n", (int) round(grade));
    }
    else if (grade >= 16)
    {
        printf("Grade 16+\n");
    }
    else
    {
        printf("Before Grade 1\n");
    }
}