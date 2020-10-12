-- Q1.  Find the names of all students who are friends with someone named Gabriel.

SELECT name
FROM Highschooler
JOIN Friend
ON Highschooler.ID = ID1
WHERE ID2 IN (SELECT ID FROM Highschooler WHERE name = 'Gabriel');

-- Q2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.

SELECT h1.name, h1.grade, h2.name, h2.grade 
FROM Highschooler h1, Highschooler h2, Likes l
WHERE l.ID1 = h1.ID
AND l.ID2 = h2.ID
AND (h1.grade - h2.grade) >= 2
AND h1.name > h2.name;


-- Q3. For every pair of students who both like each other, return the name and grade of both students.

SELECT h1.name, h1.grade, h2.name, h2.grade 
FROM Highschooler h1, Highschooler h2, Likes l1, Likes l2
WHERE (l1.ID1 = h1.ID AND l1.ID2 = h2.ID)
AND (l2.ID1 = h2.ID AND l2.ID2 = h1.ID) 
AND h1.name < h2.name; -- ensures alpha ordering and each pair only once

-- Q4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.

SELECT name, grade
FROM Highschooler
WHERE ID NOT IN 
(SELECT ID1 FROM LIKES
UNION
SELECT ID2 FROM LIKES)
ORDER BY grade, name;

-- Q5. For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.

SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Highschooler h1, Highschooler h2, Likes L
WHERE h1.ID = L.ID1 AND h2.ID = L.ID2
AND h2.ID NOT IN (SELECT ID1 FROM Likes);

-- Q6. Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.

SELECT name, grade
FROM Highschooler H1
WHERE ID NOT IN (
	SELECT ID1
	FROM Highschooler H2, Friend F
	WHERE H1.ID = F.ID1 AND H2.ID = F.ID2 AND H1.grade <> H2.grade)
ORDER BY grade, name;

-- Q7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.

SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Friend F1, Friend F2, Likes L
WHERE (H1.ID = L.ID1 AND H2.ID = L.ID2)
AND H2.ID NOT IN (
SELECT ID2
FROM Friend
WHERE ID1 = H1.ID)
AND (H2.ID = F2.ID1 AND H3.ID = F2.ID2)
AND (H1.ID = F1.ID1 AND H3.ID = F1.ID2);

-- Q8. Find the difference between the number of students in the school and the number of different first names.

SELECT COUNT(ID) - COUNT( DISTINCT name)
FROM Highschooler;

-- Q9. Find the name and grade of all students who are liked by more than one other student.
SELECT name, grade
FROM Highschooler
WHERE ID IN (
SELECT ID2 FROM LIKES
GROUP BY (ID2)
HAVING COUNT(ID2) > 1);
