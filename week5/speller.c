// Implements a dictionary's functionality

#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include <strings.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 26;

// Hash table
node *table[N];

// Variable added by me: A counter for each word added into the dictionary
int wordLoadedCount = 0;

// Returns true if word is in dictionary else false
// This is where the actual dictionary is put to work

bool check(const char *word)
{
    // Case insensetive
    // Removes apostraphes from word
    // Hash word to obtain a hash value
    int index = hash(word);

    for (node *tmp = table[index]; tmp !=  NULL; tmp = tmp->next)
    {
        if (strcasecmp(word, tmp->word) == 0)
        {
            return true;
        }
    }
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // Objective: Return a number from 0 to 25 given the first letter of the word
    int index = 26;

    // Converts first number to ascii equivilent int
    int firstletter = (int)word[0];

    // Uppercase letters
    if (firstletter >=65 && firstletter <= 90)
    {
        // We want index = 0 when ascii = 65
        index = firstletter - 65;
    }
    // Lowercase letters
    else if (firstletter >= 97 && firstletter <= 122)
    {
        // We want index = 0 when ascii = 97
        index = firstletter - 97;
    }

    // Check to make sure return value is actually between 0 & 25
    if (index == 26)
    {
        printf("We could not hash %s.\n", word);
        return -1;
    }
    return index;
}

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    // Open dictionary file
    FILE *file = fopen(dictionary, "r");
    if (file == NULL)
    {
        printf("Could not open %s.\n", dictionary);
        unload();
        return false;
    }

    // Initialize a buffer variable where we are storing each word
    char storedWord[LENGTH + 1];

    // Read strings from the file one at a time
    while (fscanf(file, "%s", storedWord) != EOF)
    {
        // Create a new node for each word
        node *newNode = malloc(sizeof(node));
        if (newNode == NULL)
        {
            printf("Your program ran out of memory!");
            return false;
        }
        // Copy the word into the new node using strcpy
        strcpy(newNode->word, storedWord);
        newNode->next = NULL;

        // Update "word loaded" count
        wordLoadedCount++;

        // Hash word to obtain value/index
        int index = hash(storedWord);
        // Checks to see if bucket of the hash table is empty
        if (table[index] == NULL)
        {
            table[index] = newNode;
            newNode->next = NULL;
        }
        // If it is not empty
        else if (table[index] != NULL)
        {
            // Points new node to the existing first node
            newNode->next = table[index];
        }
    }
    // Closes the file to release memory
    fclose(file);
    return true;
}

// Returns number of words in dictionary if loaded else 0 if not loaded
unsigned int size(void)
{
    // If dictionary was loaded..
    if (wordLoadedCount > 0)
    {
        return wordLoadedCount;
    }
    return 0;
}

// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    for (int i = 0; i < N; i++)
    {
        // copied from week 5 lecture code
        while (table[i] != NULL)
        {
            node *tmp = table[i]->next;
            free(table[i]);
            table[i] = tmp;
        }

        // Checks to see if memory is cleared to allocate hash table
        if (table[i] != NULL)
        {
            printf("Something went wrong while freeing memory in unload function.\n");
            return false;
        }
    }
    return true;
}

