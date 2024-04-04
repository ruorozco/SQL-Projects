/*
Roberto Orozco

Queries used for Covid Visualization

1.The information code is in SQL (Compiled in SQL Server MAnagement Studio)
2.Copied the SQL tables result to Excel files. (called Tableau1, Tableau2, Tableau3, Tableau4)
3.The Excels files import to TABLEAU PUBLIC 2024.1 to create the Visualization Tables, Chart, Maps
-Result are in the following link:
-https://public.tableau.com/views/CovidVisualization_17122618172640/Dashboard1?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link

*/



-- 1.(Tableau1.xlsx) 
--This table has the infromation of: Total cases, Total deaths and Percentage of Death(Global)
--It will be a 2x3 table

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Project_One..CovidDeaths
where continent is not null 
order by 1,2

-- 2. (Tableau2.xlsx) 
--This table has the ifromation of" Total deaths by each Country
--This will be an horizontal bar table

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Project_One..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.(Tableau3.xlsx) 
--This table has the information of: Population infected by country
--This will be show as a global map

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Project_One..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.(Tableau4.xlsx)
--This table has the information of: The total infected cases per Country 
--To a better picture, We select only five countries: United States, United Kingdom, Mexico, India, China
--This will be show as Line Chart

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Project_One..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc







