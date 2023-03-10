# PortfolioProjects

## Exploration of COVID-19 dataset with SQL

In this project, I explore the [Our World in Data COVID-19 dataset](https://ourworldindata.org/coronavirus#explore-the-global-situation), concentrating on cases, deaths, and vaccinations. This data is completely open access under the Creative Commons BY license and has been collected, aggregated, and documented by Edouard Mathieu, Hannah Ritchie, Lucas Rodés-Guirao, Cameron Appel, Daniel Gavrilov, Charlie Giattino, Joe Hasell, Bobbie Macdonald, Saloni Dattani, Diana Beltekian, Esteban Ortiz-Ospina, and Max Roser.  

I downloaded the complete dataset (CSV) through February 2023 and processed in Excel to create a file with death count data and a file with vaccination data for importing into Microsoft SQL Server 2022 (using Microsoft SQL Server Management Studio 2019). Using SQL, I examined the total deaths vs. total cases and the percent of the population infected over time in the United States and looked at the countries and continents with the highest death count and the countries with the highest percent of the population infected. I joined the CovidDeaths and CovidVaccinations tables and used CTE and a temp table to calculate running vaccination totals and running vaccination percent of population for each location across dates and created a view to store data for later visualizations.  

