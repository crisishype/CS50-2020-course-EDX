SELECT DISTINCT(people.name) from stars
JOIN people ON stars.person_id = people.id
JOIN movies ON stars.movie.id = movies.id
WHERE movies.year = 2004
ORDER BY birth;