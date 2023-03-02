SELECT *
FROM PortfolioProject1..CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject1..CovidVaccinations
--ORDER BY 3,4

--Select data that I am going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject1..CovidDeaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract Covid in the United States
SELECT Location, date, total_cases, total_deaths, (CAST (total_deaths as float)/CAST (total_cases as float))*100 AS DeathPercentage
FROM PortfolioProject1..CovidDeaths
WHERE Location = 'United States'
ORDER BY 1,2

--Looking at Total Cases vs Population
--Shows what percentage of the population has been reported as being infected with Covid
SELECT Location, date, total_cases, Population, (CAST (total_cases as float)/CAST (Population as float))*100 AS PercentPopulationInfected
FROM PortfolioProject1..CovidDeaths
WHERE Location = 'United States'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to Population
SELECT Location, Population, MAX (total_cases) AS HighestInfectionCount, (MAX(CAST (total_cases as float)/CAST (Population as float)))*100 AS PercentPopulationInfected
FROM PortfolioProject1..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

--Looking at countries with highest death count
SELECT Location, MAX (total_deaths) AS TotalDeathCount
FROM PortfolioProject1..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC

--Looking at continents with highest death count
SELECT continent, MAX (total_deaths) AS TotalDeathCount
FROM PortfolioProject1..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Global numbers (total global cases, deaths and death percentage); if include date and group by date, can see changes in global death rates over time.
SELECT --date, 
SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(CAST (new_deaths as float))/SUM (CAST (new_cases as float))*100 AS DeathPercentage
FROM PortfolioProject1..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--Looking at CovidVaccinations table
SELECT*
FROM PortfolioProject1..CovidVaccinations

--Join of CovidDeaths and CovidVaccinations tables
SELECT *
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

--Looking at new vaccinations and running total of vaccinations by location and date.
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS running_vac_total
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- Use CTE

With PopvsVac (continent, location, date, population, new_vaccinations, running_vac_total)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS running_vac_total
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)

Select *, (running_vac_total/CAST(Population as float))*100 AS running_vac_pct
FROM PopvsVac

--TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
running_vac_total numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS running_vac_total
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

Select *, (running_vac_total/Population)*100 AS running_vac_pct
FROM #PercentPopulationVaccinated
ORDER BY 2,3

--Creating view to store data for later visualizations.

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS running_vac_total
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated