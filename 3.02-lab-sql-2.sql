-- 1. Write a query to display for each store its store ID, city, and country.
select s.store_id,  c.city, co.country from store as s
join address as a using (address_id)
join city as c using (city_id)
join country as co using (country_id)
GROUP BY store_id;

-- 2. Write a query to display how much business, in dollars, each store brought in.
select s.store_id,  c.city, co.country, CONCAT('$ ', SUM(p.amount)) AS "Store Revenue" from store as s
join address as a using (address_id)
join city as c using (city_id)
join country as co using (country_id)
join staff using (store_id)
join payment as p using (staff_id)
group by s.store_id;

-- 3. What is the average running time of films by category?
select AVG(f.length) as 'Average length', c.name from film as f
join film_category using (film_id)
join category as c using (category_id)
group by c.name;

-- 4. Which film categories are longest?
select AVG(f.length) as 'Average length', c.name from film as f
join film_category using (film_id)
join category as c using (category_id)
group by c.name
order by avg(f.length) DESC LIMIT 1;

-- 5. Display the most frequently rented movies in descending order.
select f.title,  count(r.rental_id) as 'Rentals count' from film as f
join inventory using (film_id)
join rental as r using (inventory_id)
group by title
order by count(r.rental_id) DESC;

-- 6. List the top five genres in gross revenue in descending order.
select sum(p.amount), c.name from payment as p
join rental using(rental_id)
join inventory using(inventory_id)
join film using(film_id)
join film_category using(film_id)
join category as c using(category_id)
group by c.name
order by sum(p.amount) desc limit 5;

-- 7. Is "Academy Dinosaur" available for rent from Store 1?
select f.title, i.store_id from film as f
join inventory as i using(film_id)
where i.store_id = 2 and f.title = "Academy Dinosaur"
