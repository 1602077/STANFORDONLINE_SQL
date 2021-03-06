-- Q1. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.

SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade -- A, B & C
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L1, Likes L2
WHERE (H1.ID = L1.ID1 AND H2.ID = L1.ID2) -- A likes B
AND (H2.ID = L2.ID1 AND H3.ID = L2.ID2)  -- B likes C
AND H3.ID <> H1.ID; -- A and C are distinct 

-- Q2. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.

SELECT H1.name, H1.grade
FROM Highschooler H1
WHERE H1.grade NOT IN
(SELECT H2.grade
FROM Highschooler H2, Friend F
WHERE H1.ID = F.ID1 AND H2.ID = F.ID2);

-- Q3. What is the average number of friends per student?

SELECT AVG(FPS)
From (SELECT COUNT(*) AS FPS
FROM Friend
GROUP BY ID1) AS FPST;

-- Q4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.

SELECT count(*)
FROM Friend
WHERE ID1 IN (
SELECT ID2 
FROM Friend
WHERE ID1 IN (
SELECT ID
FROM Highschooler
WHERE name = 'Cassandra'));

-- Q5. Find the name and grade of the student(s) with the greatest number of friends.

SELECT name, grade
FROM Highschooler
WHERE ID IN (
SELECT F.ID1
FROM FRIEND F
GROUP BY F.ID1
HAVING COUNT(*) = (
SELECT  MAX(FC)
FROM (SELECT ID1, COUNT(*) AS FC
FROM Friend
GROUP BY ID1) as tmp));

