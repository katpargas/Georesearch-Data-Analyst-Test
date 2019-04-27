USE sakila;
/* Obtener el nombre de las ciudades de Chile */

/* id de Chile = 22 */

select city_id,city from city where country_id = 22;

/* Obtener los clientes asociados a la ciudad de Santiago */

select * from customer c inner join address a on c.address_id = a.address_id inner join city ci on a.city_id = ci.city_id where ci.city_id = 27;

/*Obtener las ciudades que no tienen clientes*/

SELECT distinct city FROM (SELECT * FROM address a WHERE NOT EXISTS( SELECT  * FROM customer c WHERE a.address_id = c.address_id)) a inner join city c on a.city_id = c.city_id;

/* Cantidad de arriendo de películas por tienda, ordenado de la mayor a la menor */

select s.store_id as store, count(r.rental_id) as quantity from inventory i right outer join store s on  i.store_id = s.store_id inner join rental r on i.inventory_id = r.inventory_id group by s.store_id order by quantity desc;

/* Las 5 ciudades con mayor cantidad de arriendos de películas */

select ci.city, count(r.rental_id) as quantity from inventory i right outer join store s on  i.store_id = s.store_id inner join rental r on i.inventory_id = r.inventory_id inner join address a on s.address_id = a.address_id inner join city ci on a.city_id = ci.city_id group by ci.city order by quantity desc limit 5;

/* Año/mes con mayor cantidad de arriendo de películas */

select month(rental_date), year(rental_date), count(*) as rental from rental group by month(rental_date), year(rental_date) order by rental desc limit 1;

/* La tienda con mayor cantidad de dinero por arriendo de películas */

select s.store_id as store_id, sum(p.amount) as total from payment p inner join rental r on p.rental_id = r.rental_id inner join inventory i on r.inventory_id = i.inventory_id inner join store s on i.store_id = s.store_id group by s.store_id order by total desc limit 1;

/* Clientes que más gastaron en arriendo de películas */

select c.customer_id as customer_id, c.first_name as first_name, sum(p.amount) from payment p inner join rental r on p.rental_id = r.rental_id inner join customer c on r.customer_id = c.customer_id group by c.customer_id order by sum(p.amount) desc;

/* Categoria de películas que más recaudan dinero */

select ca.name as name, sum(p.amount) as total  from film_category fc inner join category ca on fc.category_id = ca.category_id inner join film f on fc.film_id= f.film_id inner join inventory i on f.film_id = i.film_id inner join rental r on i.inventory_id = r.rental_id inner join payment p on r.rental_id = p.rental_id group by ca.name order by sum(p.amount) desc;

/* Promedio de ventas mensuales por tienda */

select sub.store as store_id, avg(sub.store_total_month) as average from (select s.store_id as store, month(p.payment_date) as store_month, year(p.payment_date) as store_year, sum(p.amount) as store_total_month from payment p inner join rental r on p.rental_id = r.rental_id inner join inventory i on r.inventory_id = i.inventory_id inner join store s on i.store_id = s.store_id group by s.store_id, month(p.payment_date), year(p.payment_date)) as sub group by sub.store;

/* Cantidad de stock de películas por categoria */

select ca.name as name, count(f.film_id) as Stock from film f inner join film_category fc on f.film_id = fc.film_id inner join category ca on fc.category_id = ca.category_id group by ca.name; 

/* Generar una vista con las ventas generadas por los vendedores de las tiendas */

 create view sales_by_staf as select sf.first_name, sum(p.amount) as total  from payment p inner join rental r on p.rental_id = r.rental_id inner join inventory i on r.inventory_id = i.inventory_id inner join store s on i.store_id = s.store_id inner join staff sf on s.manager_staff_id = sf.staff_id group by sf.staff_id;
 