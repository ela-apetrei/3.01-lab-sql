-- 1. List the number of films per category.
select count(fc.category_id) AS 'category_count', fc.category_id, c.name from film as f
join film_category as fc
on f.film_id = fc.film_id
join category as c
on fc.category_id = c.category_id
group by fc.category_id
order by count(fc.category_id) DESC;

-- 2. Display the first and the last names, as well as the address, of each staff member.
select s.first_name, s.last_name, a.address, a.district, a.postal_code from staff as s
join address as a
on s.address_id = a.address_id;

-- 3. Display the total amount rung up by each staff member in August 2005.
SELECT p.staff_id, s.first_name, s.last_name, SUM(p.amount) as 'Sum of Amount', p.payment_date FROM sakila.payment as p
join staff as s
where payment_date > '2005/08/01' and payment_date <= '2005/09/00' 
group by staff_id;

-- 4. List all films and the number of actors who are listed for each film.
select f.title, count(fa.actor_id) as 'Count of actors' from film as f
join film_actor as fa
on fa.film_id = f.film_id
join actor as a
on fa.actor_id = a.actor_id
group by fa.actor_id;


-- 5. Using the payment and the customer tables as well as the JOIN command, list the total amount paid by each customer. List the customers alphabetically by their last names.
select p.customer_id, c.first_name, c.last_name, SUM(p.amount) from payment as p
join rental as r
on p.customer_id = r.customer_id
join customer as c
on r.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name ASC