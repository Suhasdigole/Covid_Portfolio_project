/*
Queries used for Tableau Project
*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/Sum(New_cases)*100 as death_percentage	
From Portfolio_project..CovidDeaths
Where continent is not NULL
Order by 1,2


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location,sum(cast(new_deaths as int)) as Total_death_count
From Portfolio_project..CovidDeaths
--Where location like '%states%'
Where continent is NULL
and location not in ('World','European Union','International')
Group by location
Order by Total_death_count Desc


-- 3.

Select location,population, MAX(total_cases) as highest_Infection_Rate, MAX((total_cases/population))*100 as Perc_popu_Infected
From Portfolio_project..CovidDeaths
--Where location like '%states%'
Group by location,population
Order by Perc_popu_Infected Desc



-- 4.


Select location,population,date, MAX(total_cases) as highest_Infection_Rate, MAX((total_cases/population))*100 as Perc_popu_Infected
From Portfolio_project..CovidDeaths
--Where location like '%states%'
Group by location,population,date
Order by Perc_popu_Infected Desc


