select * from dbo.CovidDeath 
--where continent is not null 
order by 3,4

/**select * from dbo.CovidVacinnation order by 3,4 **/

--selecting data needed
select location, date, total_cases, new_cases, total_deaths,population 
from dbo.CovidDeath order by 1,2

--total cases vs total deaths rate in US

select location, date, total_cases, new_cases, total_deaths, 
(total_deaths/total_cases)*100 as DeathRate from CovidDeath 
where continent is not null and location like '%state%' 
order by 1,2

--Total cases vs population

select location, date, total_cases, population,  
(total_cases/population)*100 as CasesRate from CovidDeath 
where continent is not null
--where location like 'nigeria'
order by 1,2

--Countries with highest infection rate by population

select location, population, max(total_cases) as HighestCovidCases,  
max((total_cases/population)*100) as CovidCasesRate from CovidDeath
where continent is not null
group by location, population
order by CovidCasesRate desc

-- Countries with highest Death Count & DeathRate per Population

select location, population, max(cast(total_deaths as int)) as HighestDeathCount,  
max((total_deaths/population)*100) as DeathCasesRate from CovidDeath
where continent is not null
group by location, population
order by HighestDeathCount desc
--order by DeathCasesRate desc
 
-- Continent with highest Death Count & Death Per Population

select continent, max(cast(total_deaths as int)) as HighestDeathCount, max((total_deaths/population)*100) as DeathCasesRate 
from CovidDeath
where continent is not null
group by continent
order by HighestDeathCount desc


-- Global Numbers

select sum(new_cases) as TotalNewCases, sum(cast(new_deaths as int)) as TotalNewDeath,
sum(cast(new_deaths as int))/sum(new_cases)*100 as NewDeathRate
from CovidDeath
where continent is not null
--group by date
order by 1,2


--Creating View to store data for later visualization


Create View PercentPopulationVaccinated as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location,cd.date) as RollingPeopleVaccinated
from CovidDeath cd 
join CovidVacinnation cv 
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
--order by 2,3
