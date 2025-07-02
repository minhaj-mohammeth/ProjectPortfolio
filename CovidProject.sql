select *
from CovidProject..CovidDeaths
where continent is not null
order by 3,4

select *
from CovidProject..CovidVaccinations
order by 3,4

--SELECT DATA THAT WE ARE GOING TO BE USING

select location,date,total_cases,new_cases,total_deaths,population
from CovidProject..CovidDeaths
order by 1,2

--LOOKING AT TOTAL CASES VS TOTAL DEATH

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidProject..CovidDeaths
order by 1,2

--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

select location,population,max(total_cases) as HighestInfectionCount, max(total_deaths/total_cases)*100 as PercentPopulationInfected
from CovidProject..CovidDeaths
group by location,population
order by PercentPopulationInfected desc

--LOOKING AT COUNTRIES WITH HIGHEST DEATH COUNT COMPARED TO POPULATION

select location, max (cast(total_deaths as int)) as TotalDeathCount
from CovidProject..CovidDeaths
where continent is not null
GROUP BY location
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENTS

select location, max (cast(total_deaths as int)) as TotalDeathCount
from CovidProject..CovidDeaths
where continent is null
GROUP BY location
order by TotalDeathCount desc

--SHOWING CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION

select continent, max (cast(total_deaths as int)) as TotalDeathCount
from CovidProject..CovidDeaths
where continent is not null
GROUP BY continent
order by TotalDeathCount desc

--GLOBAL COUNT

select date,SUM(new_cases) as TotalCasesRecorded, SUM(CAST(new_deaths as int)) as TotalDeathsRecorded,(SUM(CAST(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
from CovidProject..CovidDeaths
where continent is not null
group by date
order by 1,2

--GLOBE

select SUM(new_cases) as TotalCasesRecorded, SUM(CAST(new_deaths as int)) as TotalDeathsRecorded,(SUM(CAST(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
from CovidProject..CovidDeaths
where continent is not null
order by 1,2

--COMBINING THE TABLES

select *
from CovidProject..CovidDeaths dea
join CovidProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

--LOOKING AT TOTAL POPULATION VS VACCINATION

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac





--TEMP TABLE


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- CREATING VIEW TO STORE DATA FOR VISUALIZATION

GO
CREATE VIEW
PercentPopulationVaccinated 
as
Select 
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
GO

Select * 
From PercentPopulationVaccinated