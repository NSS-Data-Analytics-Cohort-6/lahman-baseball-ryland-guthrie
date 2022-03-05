--Q1: What range of years for baseball games played does the provided database cover?--
SELECT MIN(year), MAX(year), (MAX(year) - MIN(year)) AS "Time Span"
FROM homegames --Answer: 1871 to 2016--

SELECT MIN(yearid), MAX(yearid), (MAX(yearid) - MIN(yearid)) AS "Time Span"
FROM teams --Answer: 1871 to 2016--


--Q2: Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?--
SELECT CONCAT(namefirst, ' ', namelast) AS Name, height, SUM(g_all) AS Total_Games_Played, name AS Team_Name, playerid
FROM people
	LEFT JOIN appearances
	USING(playerid)
	LEFT JOIN teams
	USING(teamid)
GROUP BY namefirst, namelast, name, height, playerid
ORDER BY height;

SELECT COUNT(*)
from appearances
WHERE teamid = 'SLA'
ORDER BY playerid;



--Q3: Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
SELECT p.namefirst, p.namelast, c.schoolid, SUM(s.salary), s.yearid
FROM collegeplaying AS c
	LEFT JOIN people AS p
	ON p.playerid = c.playerid
	LEFT JOIN salaries AS s
	ON s.playerid = c.playerid
WHERE schoolid = 'vandy'
GROUP BY namefirst, namelast, schoolid, salary, yearid;

SELECT schoolname, namefirst, namelast, SUM(salary) as total_salary
FROM schools
	LEFT JOIN (SELECT DISTINCT playerid, schoolid
			  FROM collegeplaying) AS cp
USING(schoolid)
LEFT JOIN people
USING(playerid)
LEFT JOIN salaries
USING(playerid)
WHERE schoolname = 'Vanderbilt University'
AND salary IS NOT NULL
GROUP BY schoolname, namefirst, namelast
ORDER BY total_salary DESC;
