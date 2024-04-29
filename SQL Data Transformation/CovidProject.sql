---Select * from dbo.CovidDeaths

--Select CovidVaccinations.iso_code, CovidVaccinations.new_tests,CovidVaccinations.continent
--from dbo.CovidVaccinations
--inner join dbo.CovidDeaths
--on CovidVaccinations.iso_code = CovidDeaths.iso_code

--- Looking at total cases vs population
Select location,population,total_cases from dbo.CovidDeaths
where location = 'South Africa'
order by 1,2

--- shows what percentage of population got covid

Select location,date,population,total_cases,total_deaths from dbo.CovidDeaths
where location = 'South Africa'
order by 3,4

--- looking at countries with highest infection rate compared to population
--- showing countries with highest death count per population

Select * from dbo.CovidVaccinations
order by 3,4


---To spend time with the data and get familiar with it.

select sum(new_cases) as TotalCases, sum(cast(new_deaths as bigint)) as TotalDeath,sum(cast(new_deaths as bigint))/sum(new_cases)*100
from CovidDeaths where continent is not null order by 1,2

select * from CovidVaccinations

---To find out the death percentage locally and globally.

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%South Africa%' and total_cases is not null
order by location,date

---To find out the death percentage per continent.

select continent, sum(total_cases) as TotalCases, sum(cast(total_deaths as bigint)) as TotalDeath,sum(cast(total_deaths as bigint))/sum(total_cases)*100 as DeathPercentage
from CovidDeaths 
where continent is not null 
group by continent

---To find out the infected population percentage locally and globally.

select location,date,total_cases,total_deaths,population,(total_cases/population)*100 as InfectedPercentage
from CovidDeaths
where location like '%South Africa%' 
order by date

select continent, sum(population) as TotalPopulation ,sum(total_cases) as TotalCases,sum(total_cases)/sum(population)*100 as InfectedPercentage
from CovidDeaths 
where continent is not null 
group by continent

---To find out countries with the highest infection rates.

select location,Max(total_cases),population,Max(total_cases/population)*100 as InfectionRate
from CovidDeaths
where continent is not null 
group by location,population
order by InfectionRate desc

---To find out the countries and continents with the highest death counts.
select continent,Max(cast(total_deaths as bigint)) as DeathRate
from CovidDeaths
where continent is not null 
group by continent
order by DeathRate desc

---Using JOINS to combine the covid_deaths and covid_vaccine tables

select CovidDeaths.iso_code,CovidDeaths.continent,total_cases,total_deaths,CovidVaccinations.total_vaccinations from CovidDeaths
inner join CovidVaccinations 
on CovidDeaths.iso_code = CovidVaccinations.iso_code
where CovidDeaths.continent is not null
group by CovidDeaths.iso_code

select location,max(population),max(total_cases) as Infected,Max(cast(total_deaths as bigint)) as Deaths,Max(cast(total_deaths as bigint))/Max(total_cases)*100 as DeathRate from CovidDeaths
where location = 'Nigeria'
group by location

---Countries with the highest infection rate compared to the population: Identified countries with the highest infection rates relative to their population.

Select location, max(total_cases),population,max(total_cases)/population*100 as InfectionRate
from CovidDeaths
where continent is not null
group by location,population
order by InfectionRate Desc

---Total population Vs Vaccinations: Explored the relationship between the total population and the number of COVID-19 vaccinations administered.

Select CovidD.iso_code,CovidD.location,Max(CovidD.population) as Population,Max(cast(CovidV.total_vaccinations as bigint)) as TotalVaccinations  
from CovidDeaths as CovidD
join CovidVaccinations as CovidV on
CovidD.iso_code = CovidV.iso_code
group by CovidD.location, CovidD.iso_code
order by TotalVaccinations DESC


--- Create a View for visualization

Create VIEW TotalVaccination as
(Select CovidD.iso_code,CovidD.location,Max(CovidD.population) as Population,Max(cast(CovidV.total_vaccinations as bigint)) as TotalVaccinations  
from CovidDeaths as CovidD
join CovidVaccinations as CovidV on
CovidD.iso_code = CovidV.iso_code
group by CovidD.location, CovidD.iso_code
)

select * from TotalVaccination 
order by TotalVaccinations DESC