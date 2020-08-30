import csv
from cs50 import SQL
from sys import argv, exit

def partition_name(full_name):
    names = full_name.split() #"Harry Potter" -> ["Harry", None, "Potter"]
    return names if len(names) >= 3 else [ names[0], None, names[1] ]
# check that we launched the code with proper arguments, otherwise it exits the program
if len(argv) != 2:
    print("usage error, roster.py houseName")
    exit(1)

# open the database in a variable and then execute a query that list all the people from a particular house in alphabetical order
db = SQL("sqlite:///students.db")

csv_path = argv[1]
with open(csv_path) as csv_file:
    reader = csv.DictReader(csv_file)
    for row in reader:
        names = partition_name(row["name"])
        db.execute("INSERT INTO students(first, middle, last, house, birth) VALUES(?, ?, ?, ?, ?)",
            names[0], names[1], names[2], row["house"], row["birth"]
        )