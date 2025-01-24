/*

Queries used for Tableau Project

*/



-- 1. Query 1 for Excel

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From SQLDataProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- 2.  Query 2 for Excel

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From SQLDataProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3. Query 3 for Excel

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max(cast(total_cases as float)/cast(population as float))*100 as PercentPopulationInfected
From SQLDataProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4. Query 4 for Excel


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((cast(total_cases as float)/cast(population as float)))*100 as PercentPopulationInfected
From SQLDataProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

