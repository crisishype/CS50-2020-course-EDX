SELECT movies.title FROM people
JOIN stars ON people.id = stars.person_id
WHERE people.name = "Johhny Depp" AND movies.title IN()
SELECT movies.title FROM people
JOIN stars ON people.id = stars.person_id
JOIN movies ON stars.movie_id = movies.id
WHERE people.name = "Helena Bonman Carter");