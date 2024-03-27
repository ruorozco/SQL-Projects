/*
Roberto Orozco
Covid 19-Data Explotarion
Skills used: Joins, CTE's, Temp Tables, Windows Funtions
Creating Views, Converting Data Types
*/
--This project is following the project of Alex The Analyst from his Bootcamp


--Starting commands just to check that the Data from exel is working
SELECT *
FROM Project_One..CovidDeaths
order by 3,4;

SELECT *
FROM Project_One.. CovidVaccinations
order by 3,4;

--Select data that to work
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Project_One..CovidDeaths
WHERE continent is not null
Order by 1,2;

--Looking at The Total Cases vs Total DEath
--Opertation death/cases RETURN the average (CASE FATALITY RATE)
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)
FROM Project_One..CovidDeaths
order by 1,2;

--Total Cases vs Daeths
--RETURN probability of death of each county TEST Mexico and USA
SELECT Location, date ,Population, total_cases, total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
FROM Project_One..CovidDeaths
--WHERE location like '%mexico%'
WHERE location like '%United States%'
ORDER BY 1,2

--Total Cases vs Population
--RETURN percentage of population infected 
SELECT Location, date, population, total_cases,
(total_cases/population)*100 as PopInfectedPercentage
FROM Project_One..CovidDeaths
ORDER BY 1, 2

--Countries with Highest Infection Rate 
SELECT Location, Population, MAX(total_cases) as HigestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM Project_One..CovidDeaths
--WHERE location like '%Mexico%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

--Countries with Highest Death per Population
SELECT Location,Population, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM Project_One..CovidDeaths
WHERE continent is not null
GROUP BY Location,Population
ORDER BY TotalDeathCount DESC

--CONTINENT with Highest death pero Population
SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM Project_One..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--GLOBAL 
SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths
FROM Project_One..CovidDeaths
WHERE continent is not null
--WHERE total_cases is not null
GROUP BY date
ORDER BY 1,2

--Look for populatrion vs vacination
SELECT dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations
From Project_One..CovidDeaths dea
JOIN Project_One..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--CTE (Run since With util second select-from
With PopvsVac (Continent, Location, Date, Population, 
New_Vaccinations, RollingPepleVaccinate)
as(
SELECT dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location,
dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM Project_One..CovidDeaths dea
JOIN Project_One..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (RollingPepleVaccinate/Population)*100
FROM PopvsVac


--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location,
dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM Project_One..CovidDeaths dea
JOIN Project_One..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

--VIEW to Store data for later Visalizations
CREATE VIEW PercentPopulation as
SELECT dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location,
dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM Project_One..CovidDeaths dea
JOIN Project_One..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3  
 


