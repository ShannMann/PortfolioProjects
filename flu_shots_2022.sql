/*
Objective: prepare data for flu shot dashboard for 2022 including:
1. Total percentage of patients that received flu shots stratified by
	a. age
	b. race
	c. county (on a map)
	d. overall
2. Running total of flu shots over the course of 2022
3. Total number of flu shots given in 2022
4. A list of patients showing whether or not they received a flu shot


Requirements: 
patient must have been "active at the hospital"
patients must be 6 months of age or older (eligible for flu shot)
*/

/*
Create CTE with patient ids for active patients who had an encounter with
the hospital between 2020 and 2022, were not dead, and were at least 6 months of age
*/
with active_patients as
(
	select distinct patient
	from encounters as e
	join patients as pt
	   on e.patient = pt.id
	where start between '2020-01-01 00:00' and '2022-12-31 23:59'
	   and pt.deathdate is null
	   and AGE('2022-12-31', birthdate) >= INTERVAL '6 months'
),


/* 
create CTE with patient id of patients that had flu shots in 2022, returning just
first flu shot in 2022 for each patient
5302 is the code for seasonal flu vaccine
*/
flu_shot_2022 as
(
select patient
	   ,min(date) as earliest_flu_shot_2022
from immunizations
where code = '5302'
   and date between '2022-01-01 00:00' and '2022-12-31 23:59'
group by patient
)

/*
left join with patient table first so all patients will be included whether
or not they had a flu shot
subquery in the where statement to limit to just the active patients
*/ 
select pt.birthdate
	   ,extract(YEAR FROM age('2022-12-31', birthdate)) as age
	   ,pt.race
	   ,pt.county
	   ,pt.id
	   ,pt.first
	   ,pt.last
	   ,flu.earliest_flu_shot_2022
	   ,case when flu.patient is not null then 1
	   else 0
	   end as flu_shot_2022
from patients as pt
left join flu_shot_2022 as flu
   on pt.id = flu.patient
where 1=1
   and pt.id in (select patient from active_patients)