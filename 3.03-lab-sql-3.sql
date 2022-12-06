-- 1. Get all pairs of actors that worked together.
select 
	fa1.film_id,
    fa1.actor_id actor_1,
    fa2.actor_id actor_2
from 
	film_actor fa1
inner join 
	film_actor fa2 on fa1.actor_id > fa2.actor_id
and fa1.film_id = fa2.film_id
order by
	film_id,
    actor_1,
    actor_2;
    
-- 2. Get all pairs of customers that have rented the same film more than 3 times. (here I tried to bring the customer name also but it didn't work)
select 
	j1.customer_id, j1.customer_name, j2.customer_id, j2.customer_name, j1.film_id
from 
	(select 
		c.customer_id, film_id,count(rental_id), concat(c.first_name, ' ', c.last_name) as customer_name
        from customer as c
	  join rental using(customer_id)
      join inventory using(inventory_id)
      Group by c.customer_id, film_id
      having count(rental_id) > 1) j1
join (select 
		c.customer_id, film_id,count(rental_id), concat(c.first_name, ' ', c.last_name) as customer_name
		from customer as c
	  join rental using(customer_id) 
      join inventory using(inventory_id)
      Group by c.customer_id, film_id
      having count(rental_id) > 1) j2
on
	j1.customer_id > j2.customer_id
    and
    j1.film_id = j2.film_id
    and
    j1.customer_id = j2.customer_id;
 
-- 3. Get all possible pairs of actors and films.
select * from (
  select distinct title from film 
) sub1
cross join (
  select distinct actor_id from film_actor
) sub2