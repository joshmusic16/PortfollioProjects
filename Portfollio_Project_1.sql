--Countries with highest death count per population
WITH Death_Percent (location,population, Total_Death_Count) AS
(
SELECT location, MAX(population), MAX(CAST(total_deaths AS BIGINT)) AS Total_Death_Count
FROM Portfollio_project..Covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
)
SELECT *, (Total_Death_Count/population)*100 AS Total_Death_Percent
FROM Death_Percent
ORDER BY Total_Death_Count DESC;



--United States infection over time
WITH PopvsInf (Location, Date, population,Rolling_People_Infected)
as
(
SELECT location, date, population,
SUM(CONVERT(INT,new_cases)) OVER (PARTITION BY location ORDER BY location, Date) as Rolling_People_Infected
FROM Portfollio_project..Covid_deaths
WHERE location = 'United States'
)
Select *, (Rolling_People_Infected/population)*100 AS Percent_People_Infected
From PopvsInf
ORDER BY Percent_People_Infected;



--New deaths comapared to population as percent, in relation to rolling people vaccinated 
SELECT  d.location, d.date, d.population, 
MAX((i.new_deaths/i.population))*100 AS Percent_new_deaths,
SUM(CAST(i.new_vaccinations AS BIGINT))
OVER (PARTITION BY d.location ORDER BY d.location, d.Date) 
AS Rolling_People_Vaccinated
FROM Portfollio_project..Covid_deaths AS d
JOIN Portfollio_project..Covid_info AS i
ON d.location = i.location 
and d.date = i.date
WHERE d.continent IS NOT NULL
GROUP BY d.location, d.date, d.new_deaths, i.new_vaccinations, d.population
ORDER BY Percent_new_deaths DESC;


