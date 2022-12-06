-- The Degrees of Relationships between two entities (columns/tables) is the number of entities involved in that relationship:
-- Examples from sakila:
-- One to One - if every store is located in only one city and there is only one store per city.
				-- so, every unique store_id is directly associated to just one city_id and vice-versa.
-- One to Many - if every customer is associated with one city, but many customers can live in the same city.
				-- so, every unique customer_id is associated with a city_id, but, the same city_id can be associated to different customers.
-- Many to Many - if a movie could have more than one category, you'd have more than one category per movie and more than a movie per category.
				-- so, more than one movie_id is associated with more than one category and vice-versa.


# Simple joins

select * from bank.loan as l
join bank.account as a
on l.account_id = a.account_id; -- using(account_id)

select * from bank.loan as l
left join bank.account as a
on l.account_id = a.account_id;

select * from bank.account
right join bank.loan
on account.account_id = loan.account_id;

select * from bank.account a
left join bank.loan l
on a.account_id = l.account_id;

select * from bank.loan l
right join bank.account a
on l.account_id = a.account_id;

/*
return account_id, operation, frequency, sum of amount, sum of balance, by account_id,
where total amount and total balance are bigger then 500.000, considering only transactions where the balance is over 1000 and operation type is VKLAD
*/

-- 1) return account_id, operation, frequency, sum of amount, sum of balance, 
-- 2) where the balance is over 1000 and operation type is VKLAD and
-- 3) group by (sum of amount, sum of balance) -- aggregation
-- 4) having an aggregated amount over 500,000.

select account_id, operation, frequency, sum(amount), sum(balance) from trans
join account using(account_id) -- on trans.account_id = account.account_id
where balance > 1000 and operation = 'VKLAD'
group by account_id
having sum(amount) > 500000;


-- Multiple Joins

select * from bank.disp d
join bank.client c
on d.client_id = c.client_id
join bank.card ca
on d.disp_id = ca.disp_id;

-- Logical order of joins:
-- 1st join:
-- from bank.disp -- this is our left table
-- join bank.client c -- this is our right table
-- 2nd join:
-- from bank.disp d join bank.client c -- this is our left table
-- join bank.card ca -- this is our right table

-- Temporary Tables
create temporary table if not exists bank.loan_and_account
select l.loan_id, l.account_id, a.district_id, l.amount, l.payments, a.frequency
from bank.loan l
join bank.account a
on l.account_id = a.account_id;

select * from bank.loan_and_account;

create temporary table if not exists bank.disp_and_account
select d.disp_id, d.client_id, d.account_id, a.district_id, d.type
from disp d
join account a
on d.account_id = a.account_id;

select * from bank.disp_and_account;

-- Compound Conditions
select * from bank.loan_and_account la
join bank.disp_and_account da
on la.account_id = da.account_id
and la.district_id = da.district_id;




