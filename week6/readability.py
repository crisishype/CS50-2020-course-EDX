# This program calculates the difficulty of a body of text by assigning it a grade
from cs50 import get_string

# Gets a string
s = get_string("Text: ").strip()
num_words, num_letters, num_sentences = 0, 0, 0

# checks for spaces
for i in range(len(s)):
    if (i == 0 and s[i] != ' ') or (i !=  len(s) - 1 and s[i] == ' ' and s[i + 1] != ' '):
        num_words += 1
    # Checks if upper
    if s[i].isalpha():
        num_letters += 1
    # Checks for exclamations etc.
    if s[i] == '.' or s[i] == '?' or s[i] == '!':
        num_sentences += 1

# Divides and gets the number
L = num_letters / num_words * 100
S = num_sentences / num_words * 100
index = round(0.0588 * L - 0.296 * S - 15.8)

# Tells the grade level
if index < 1:
    print("Before grade 1")
elif index >= 16:
    print("Grade 16+")
else:
    print(f"Grade {index}")