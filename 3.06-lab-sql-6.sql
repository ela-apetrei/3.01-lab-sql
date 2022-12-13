-- 1. List each pair of actors that have worked together.
select a1.film_id, a1.actor_id, a2.actor_id from film_actor a1
join film_actor a2 on a1.film_id = a2.film_id
and a1.actor_id > a2.actor_id;

-- 2. For each film, list actor that has acted in more films.

select film_id, title, a.actor_id, a.actor_name from film
join (
select film_Actor.actor_id, concat(first_name, ' ' ,last_name) as actor_name, count(film_id) as number_of_films from film_actor 
join actor
on film_actor.actor_id = actor.actor_id
group by actor_id, actor_name
order by number_of_films desc) as a;

with cte as (
	select*,
    row_number() over (partition by film_id order by total_films desc) AS flag
    from (
		select film_id, actor_id, total_films
        from (
			select actor_id, count(film_id) as total_films
            from film_actor
        group by actor_id
        )
        sub1
        join film_actor using(actor_id)
        ) sub2
)
	select film_id, actor_id, total_films from cte
    where flag = 1;