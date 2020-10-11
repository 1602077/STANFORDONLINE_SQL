-- Q1. Find the names of all reviewers who rated Gone with the Wind.

SELECT DISTINCT name
FROM Reviewer
INNER JOIN Rating USING(rID)
INNER JOIN Movie USING(mID)
WHERE title = 'Gone with the Wind';

-- Q2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.

SELECT name, title, stars
FROM Reviewer
INNER JOIN Rating USING(rID)
INNER JOIN Movie USING(mID)
WHERE director = name;

-- Q3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)

SELECT name FROM Reviewer
UNION
SELECT title FROM Movie;

-- Q4. Find the titles of all movies not reviewed by Chris Jackson.

SELECT DISTINCT title
FROM Movie
WHERE mID NOT IN 
(SELECT mID 
FROM (Reviewer NATURAL JOIN Rating) 
WHERE name = "Chris Jackson");

-- Q5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.

SELECT DISTINCT R1.name, R2.name
FROM (Reviewer NATURAL JOIN Rating) R1,
(Reviewer NATURAL JOIN Rating) R2
WHERE R1.mID = R2.mID AND R1.name < R2.name
ORDER BY R1.name, R2.name;

-- Q6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.

SELECT name, title, stars
FROM Rating
INNER JOIN Reviewer USING(rID)
INNER JOIN Movie USING(mID)
WHERE stars = (SELECT MIN(stars) FROM Rating);

-- Q7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.

SELECT title, avg_stars
FROM Movie,
(SELECT mID, AVG(stars) AS avg_stars FROM Rating GROUP BY mID) R
WHERE Movie.mID = R.mID
ORDER BY avg_stars DESC, title;

-- Q8. Find the names of all reviewers who have contributed three or more ratings

SELECT name
FROM Reviewer NATURAL JOIN Rating
GROUP BY name
HAVING COUNT(name)>=3;

-- Q9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title.

SELECT title, director
FROM Movie
WHERE director IN
(SELECT director FROM Movie
GROUP BY director
HAVING COUNT(director) >1)
ORDER BY director, title;

-- Q10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 

-- building on from q7
SELECT title, avg_stars
FROM Movie,
(SELECT mID, AVG(stars) AS avg_stars FROM Rating GROUP BY mID) R
WHERE Movie.mID = R.mID
AND R.avg_stars IN
(SELECT MAX(avg_stars) as max_stars FROM
 (SELECT mID, AVG(stars) as avg_stars FROM Rating
  GROUP BY mID));

-- Q11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.

-- swap max to min from q10
SELECT title, avg_stars
FROM Movie,
(SELECT mID, AVG(stars) AS avg_stars FROM Rating GROUP BY mID) R
WHERE Movie.mID = R.mID
AND R.avg_stars IN
(SELECT MIN(avg_stars) as min_stars FROM
 (SELECT mID, AVG(stars) as avg_stars FROM Rating
  GROUP BY mID));

  --Q12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.

SELECT director, title, MAX(stars)
FROM Movie, Rating
WHERE Movie.mID = Rating.mID
AND director IS NOT NULL
GROUP BY director;

