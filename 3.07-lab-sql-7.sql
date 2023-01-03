-- 1. Get number of monthly active customers.
create or replace view sakila.user_activity as
select customer_id, convert(rental_date, date) as Activity_date,
	date_format(convert(rental_date,date), '%m') as Activity_Month,
	date_format(convert(rental_date,date), '%Y') as Activity_year
from sakila.rental;

select * from sakila.user_activity;

-- step 2: getting the total number of active user per month and year
create or replace view sakila.monthly_active_users as
select Activity_year, Activity_Month, count(distinct customer_id) as Active_users
from sakila.user_activity
group by Activity_year, Activity_Month;

select * from monthly_active_users;

-- 2. Active users in the previous month.
select 
   Activity_year, 
   Activity_month,
   Active_users, 
   lag(Active_users) over (order by Activity_year, Activity_Month) as Last_month  -- partition by Activity_year
from monthly_active_users;

-- 3. Percentage change in the number of active customers.
with monthly_active_users as
-- in the cte we get last months aftive users with 1ag()
( 
select
	Activity_year, Activity_month, Active_users,
	lag(Active_users,1) over (order by Activity_year, Activity_month) as last_month
from monthly_active_users
)
select
activity_year, activity_month, Active_users, last_month,

-- subtract this months users with last months and calculate the percentage
(Active_users-last_month)/Active_users*100 as percentage_change
from monthly_active_users
where last_month is not null;


-- 4. Retained customers every month.
with cte as
(
	select distinct customer_id, activity_month, activity_year
	from rental
	right join disp using(rental_id)
	where (activity_month = 07 or activity_month = 06) and activity_year = 2005
)
select customer_id
from cte cte1
where activity_month = 06
and customer_id in
(
	select customer_id
    from cte cte2
    where activity_month = 07
);