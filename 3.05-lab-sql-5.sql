-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(inventory_id) from inventory
join film using(film_id)
where title = "Hunchback Impossible";

-- 2. List all films whose length is longer than the average of all the films.
select title, length from film
where length > (select avg(length) from film)
group by title;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
-- inner subquery
select film_id from films where title = 'Alone Trip';

-- middle subquery
select actor_id from film_actor 
where film_id = (select film_id from film where title = 'Alone Trip');

-- final query. I've added also a join to get the movie title but it seems like it doesn't keep count of the filter on title. Because, Karl Berry for instance shows in other movies, ours included.
select a.first_name, a.last_name, f.title
from actor a
join film_actor using(actor_id)
join film f using(film_id)
where actor_id in (select actor_id from film_actor 
where film_id = (select film_id from film where title = 'Alone Trip'))
group by a.first_name, a.last_name;

-- this is without joints
select a.actor_id, a.first_name, a.last_name
from actor a
where actor_id in (select actor_id from film_actor 
where film_id = (select film_id from film where title = 'Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title from film 
where film_id in (select film_id from film_category 
where film_id = (select category_id from category 
where name = "Family"));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select email from customer 
where address_id in (select address_id from address
where address_id in	(select city_id from city 
where country_id =(select country_id from country 
where country = "Canada")));

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select title from film
where film_id in (select film_id from film_actor
where actor_id = (select actor_id from film_actor
group by actor_id order by count(film_id) desc limit 1));

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select first_name, last_name from customer
where customer_id in (select customer_id from customer 
where customer_id = (select customer_id from payment 
group by customer_id order by sum(amount) desc limit 1));

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select customer_id, sum(amount) as total_amount_spent from payment 
group by customer_id
having total_amount_spent > (select avg(amount) as average from payment);

select customer_id, sum(amount) as total_amount_spent from payment 
group by customer_id
having total_amount_spent > (select avg(amount) as average from payment);