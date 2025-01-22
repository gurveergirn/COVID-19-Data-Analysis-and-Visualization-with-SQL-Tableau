Select *
from SQLDataProject..CovidDeaths
where continent is not null
order by 3,4

--Select *
--from SQLDataProject..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
from SQLDataProject..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths in Canada
--Shows the likelihood of dying if you contract covid in Canada
Select Location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 as DeathPercentage
from SQLDataProject..CovidDeaths
where location like '%canada%'
and continent is not null
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage contracted Covid
Select Location, date, Population, total_cases, (CAST(total_cases AS FLOAT) / CAST(Population AS FLOAT)) * 100 as PercentPopulationInfected
from SQLDataProject..CovidDeaths
where location like '%canada%'
and continent is not null
order by 1,2

--Looking at Countries with Highest Infections Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((CAST(total_cases AS FLOAT) / CAST(Population AS FLOAT))) * 100 as PercentPopulationInfected
from SQLDataProject..CovidDeaths
--where location like '%canada%'
Group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from SQLDataProject..CovidDeaths
--where location like '%canada%'
where continent is not null
Group by location
order by TotalDeathCount desc

-- Breaking Things Down by Continent


-- Showing continents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from SQLDataProject..CovidDeaths
--where location like '%canada%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global Numbers
Select  date, SUM(new_cases) as total_cases, sum(new_deaths) as total_deaths, SUM(new_deaths)/sum(new_cases) * 100 as PercentPopulationInfected
from SQLDataProject..CovidDeaths
--where location like '%canada%'
where continent is not null
group by date
order by 1,2

--Global Death Percentage
Select  SUM(new_cases) as total_cases, sum(new_deaths) as total_deaths, SUM(new_deaths)/sum(new_cases) * 100 as PercentPopulationInfected
from SQLDataProject..CovidDeaths
--where location like '%canada%'
where continent is not null
--group by date
order by 1,2


-- Looking at Total Population vs Vaccinations

--use CTE
with PopvsVac (Continent, location, date, population, New_Vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--(
From SQLDataProject..CovidDeaths dea
join SQLDataProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (cast(RollingPeopleVaccinated as float)/ cast(Population as float)) * 100
from PopvsVac


-- TEMP table

--drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--(
From SQLDataProject..CovidDeaths dea
join SQLDataProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (cast(RollingPeopleVaccinated as float)/ cast(Population as float)) * 100
from #PercentPopulationVaccinated


-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--(
From SQLDataProject..CovidDeaths dea
join SQLDataProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * 
from PercentPopulationVaccinated