Select *
From Portfolio_project..CovidDeaths
--Where continent is NOT NULL
Order by 3,4

--Select *
--From Portfolio_project..CovidVaccinations
--Order by 3,4

--Selecting the data that we are going to be using
--Shows the chances or percentage of dying if you get covid
Select location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From Portfolio_project..CovidDeaths
Where location like '%India%'
Order by 1,2

--total cases vs the population
--Shows what percentage of population has got covid
Select location,date, total_cases, population, (total_cases/population)*100 as TotalcasesByPopulation
From Portfolio_project..CovidDeaths
Where location like '%states%'
Order by 1,2


--looking at countries having higest infection rate as per their population
Select location,population, MAX(total_cases) as highest_Infection_Rate, MAX((total_cases/population))*100 as Perc_popu_Infected
From Portfolio_project..CovidDeaths
--Where location like '%states%'
Group by location,population
Order by Perc_popu_Infected Desc

--Countries having highest death count as per thier population
Select Location,MAX(cast(total_deaths as int)) as Total_death_count
From Portfolio_project..CovidDeaths
--Where location like '%states%'
Where continent is NOT NULL
Group by Location
Order by Total_death_count Desc

--Countries having highest death count by continent (The figures are more correct when the continent value is null and we select by loction)
Select Continent,MAX(cast(total_deaths as int)) as Total_death_count
From Portfolio_project..CovidDeaths
--Where location like '%states%'
Where continent is not NULL
Group by Continent
Order by Total_death_count Desc

--Total cases in the whole world nd its percentage
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/Sum(New_cases)*100 as death_percentage	
From Portfolio_project..CovidDeaths
Where continent is not NULL
Order by 1,2

--Covid vaccintation table
select *
from Portfolio_project..CovidVaccinations
select *
from Portfolio_project..CovidDeaths


select *
from Portfolio_project..CovidDeaths dea
Join Portfolio_project..CovidVaccinations vac
	ON dea.location=vac.location
	and dea.date=vac.date


--Looking at total population vs vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from Portfolio_project..CovidDeaths dea
Join Portfolio_project..CovidVaccinations vac
	ON dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3


--USING CTE

With PopvsVac (continent, date, location, population,New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over	(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Portfolio_project..CovidDeaths dea
Join Portfolio_project..CovidVaccinations vac
	ON dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


--creating a temp table

Create table #PercentPopulationVaccintated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccintated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over	(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Portfolio_project..CovidDeaths dea
Join Portfolio_project..CovidVaccinations vac
	ON dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccintated



--Creating view to store data for visualizations for later

Create View PercentPopulationVaccintated2 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over	(partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Portfolio_project..CovidDeaths dea
Join Portfolio_project..CovidVaccinations vac
	ON dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select * 
from PercentPopulationVaccintated