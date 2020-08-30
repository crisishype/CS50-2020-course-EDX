from cs50 import get_int

# Ask user for input between 0 and 8
height = 0
while (height > 8 or height < 1):
    height = get_int("Height: ")

    # Prints a pyramid of hashes
    for i in range(1, height + 1):
        print(" " * (height - i), end="")
        print("#" * (i))