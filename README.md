# PortfolioProjects

## Exploration of COVID-19 dataset with SQL

In this project, I explore the [Our World in Data COVID-19 dataset](https://ourworldindata.org/coronavirus#explore-the-global-situation), concentrating on cases, deaths, and vaccinations. This data is completely open access under the Creative Commons BY license and has been collected, aggregated, and documented by Edouard Mathieu, Hannah Ritchie, Lucas Rodés-Guirao, Cameron Appel, Daniel Gavrilov, Charlie Giattino, Joe Hasell, Bobbie Macdonald, Saloni Dattani, Diana Beltekian, Esteban Ortiz-Ospina, and Max Roser.  

I downloaded the complete dataset (CSV) through February 2023 and processed in Excel to create a file with death count data and a file with vaccination data for importing into Microsoft SQL Server 2022 (using Microsoft SQL Server Management Studio 2019). Using SQL, I examined the total deaths vs. total cases and the percent of the population infected over time in the United States and looked at the countries and continents with the highest death count and the countries with the highest percent of the population infected. I joined the CovidDeaths and CovidVaccinations tables and used CTE and a temp table to calculate running vaccination totals and running vaccination percent of population for each location across dates and created a view to store data for later visualizations.  

## Cleaning Dataset with SQL

In this project, I demonstrate a variety of approaches to cleaning a dataset with SQL. I've included the Nashville Housing dataset used in the project in this repository. I converted date format, self joined the table to identify data that could populate null values, broke out addresses into separate columns using SUBSTRING and PARSENAME
functions, updated tables, used a CASE statement to standardize entries, set up a CTE to identify and remove duplicates, and deleted unused columns.

## Simple Linear Regression with Python

In this project, I examine marketing data to determine predictors of sales. I use Python to perform exploratory data analysis, to create visualizations to explore relationships between variables and evaluate linear regression assumptions, to build and fit a simple linear regression model, and to summarize the model for evaluation and interpretation.
