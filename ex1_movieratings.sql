-- Q1. Find the titles of all movies directed by Steven Spielberg.

select title
from movie
where director = 'Steven Spielberg';

-- Q2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

select distinct movie.year
from movie, rating
where movie.mID = rating.mID and stars >= 4
order by year;

-- Q3. Find the titles of all movies that have no ratings.

select title
from Movie
where mId not in (select mID from Rating);

-- Q4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

select name
from Reviewer
where rID in (select rID from Rating where ratingDate is NULL);

-- Q5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

select name, title, stars, ratingDate from rating, reviewer, movie
where movie.mID = rating.mID and reviewer.rID = rating.rID
order by name, title, stars;

-- Q6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

select distinct name, title from movie, reviewer, rating
where reviewer.rID in (
select  r1.rID from rating r1, rating r2
where r1.rID = r2.rID and r1.mID = r2.mID and r2.ratingDate > r1.ratingDate and r2.stars > r1.stars) 
and movie.mID = rating.mID and reviewer.rID = rating.rID;

-- Q7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

select distinct title, stars
from Rating r1, movie
where stars = (select max(stars) from rating r2 where r1.mID = r2.mID)
and movie.mID = r1.mID
order by title;

-- Q8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

select title, (max(stars) - min(stars)) as rating_spread
from movie
inner join rating using(mID)
group by mId
order by rating_spread desc, title;

-- Q9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980.

select AVG(before1980.avg) - AVG(after1980.avg)
from (
  select AVG(stars) as avg
  from Movie
  inner join Rating using(mId)
  where year < 1980
  group by mId
) as before1980, (
  select AVG(stars) as avg
  from Movie
  inner join Rating using(mId)
  where year > 1980
  group by mId
) as After1980;
