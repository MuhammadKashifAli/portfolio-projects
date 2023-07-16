-- This is Guided Portfolio Project Related to Data Exploration
-- Special Credits to AlexTheAnalyst

Use PortfolioProject;
select * from coviddeaths;
select * from covidvaccinations order by 2, 3;


-- Looking at Total Cases & Total Death 
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS Death_Percentage
FROM
    coviddeaths
    Where location like '%tan'
ORDER BY 1 , 2;

-- Looking at Total Cases & Population
SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS Population_Percent
FROM
    coviddeaths
    Where location like '%tan'
ORDER BY 1 , 2;


-- Looking at Countries with Highest Infection Rates Compared to Population
SELECT 
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    coviddeaths
GROUP BY population , location
ORDER BY PercentPopulationInfected DESC;



-- Looking Countries with Highest Death Count
 SELECT 
    location, Max(CAST(total_deaths AS SIGNED)) AS Total_Death_Count
FROM
    coviddeaths
GROUP BY location
ORDER BY Total_Death_Count DESC;



-- Look for the Continent with Highest Death Count
SELECT 
    continent, Max(CAST(total_deaths AS SIGNED)) AS Total_Death_Count
FROM
    coviddeaths
    Where continent is not null
GROUP BY continent
ORDER BY Total_Death_Count DESC;



-- Global Numbers
Select Sum(new_cases) as Total_Cases, sum(cast(new_deaths as Signed)) as Total_Death, sum(cast(new_deaths as Signed))/sum(new_cases) *100 as DeathPercentage
from coviddeaths
order by date;

-- Exploring New Table
Select * from covidvaccinations;


-- Join Coviddeaths & CovidVaccinations
SELECT 
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations,
    sum(Convert(cv.new_vaccinations, Signed)) over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
FROM
    coviddeaths cd
        JOIN
    covidvaccinations
    cv ON cd.location = cv.location
        AND cd.date = cv.date;
  
  
 -- Use CTE       
 
 With CTE1 (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
 as
 (SELECT 
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations,
    sum(Convert(cv.new_vaccinations, Signed)) over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
FROM
    coviddeaths cd
        JOIN
    covidvaccinations
    cv ON cd.location = cv.location
        AND cd.date = cv.date
        Order by 2, 3
   )     
        Select *, (RollingPeopleVaccinated/population)/100 from CTE1;


-- Create View for Total Cases & Population
Create View TotalCases_Population as
SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases / population) * 100 AS Population_Percent
FROM
    coviddeaths
    Where location like '%tan'
ORDER BY 1 , 2;



-- Creating a Temp Table
Drop Table if exists CustomTable;
Create temporary table CustomTable(
continent varchar(255),
location varchar(255),
population int
);
Insert into CustomTable
SELECT 
    cd.continent,
    cd.location,
    cd.population
FROM
    coviddeaths cd
        JOIN
    covidvaccinations
    cv ON cd.location = cv.location;
Select * from CustomTable;

