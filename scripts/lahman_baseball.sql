--Q1: What range of years for baseball games played does the provided database cover?--
SELECT MIN(year), MAX(year), (MAX(year) - MIN(year)) AS "Time Span"
FROM homegames --Answer: 1871 to 2016--

SELECT MIN(yearid), MAX(yearid), (MAX(yearid) - MIN(yearid)) AS "Time Span"
FROM teams 
--Answer: 1871 to 2016--


--Q2: Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?--
SELECT CONCAT(namefirst, ' ', namelast) AS Name, height, SUM(g_all) AS Total_Games_Played, name AS Team_Name, yearid
FROM people
	LEFT JOIN appearances
	USING(playerid)
	LEFT JOIN teams
	USING(teamid,yearid)
GROUP BY namefirst, namelast, name, height, playerid, g_all, yearid
ORDER BY height;
--Answer: Eddie Gaedel; height--43; team name--ST. Louis Browns; total games played--1


--Q3: Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
SELECT namefirst, namelast, schoolname, SUM(salary) AS total_salary
FROM SCHOOLS
	LEFT JOIN (SELECT DISTINCT playerid, schoolid 
	FROM collegeplaying) AS subquery
	USING(schoolid)
	LEFT JOIN people
	USING(playerid)
	LEFT JOIN salaries
	USING(playerid)
WHERE schoolname = 'Vanderbilt University'
AND salary IS NOT NULL
GROUP BY namefirst, namelast, schoolname, playerid
ORDER BY total_salary DESC;
--Answer: David Price--


--Q4: Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
With group_table AS 
	(SELECT playerid, pos, po, yearid,
		CASE WHEN pos = 'SS' OR pos = '1B' OR pos = '2B' OR pos = '3B' THEN 'Infield'
			WHEN pos = 'P' OR pos = 'C' THEN 'Battery'
			WHEN pos = 'OF' THEN 'Outfield' END AS position_group
			FROM fielding)
SELECT position_group, SUM(po)
FROM group_table
WHERE yearid = '2016'
GROUP BY position_group;
--Answer: Battery--41424, Infield--58934, Outfield--29560


--Q5: Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
SELECT *
FROM teams

