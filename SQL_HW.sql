USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.

SELECT first_name, last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT CONCAT(first_name, ' ', last_name) AS `Actor Name`
 FROM actor;
 
 -- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
 
 SELECT actor_id, first_name, last_name
 FROM actor
 WHERE first_name = 'Joe';
 
 -- 2b. Find all actors whose last name contain the letters GEN.
 
 SELECT first_name AS `First Name`, last_name AS `Last Name`
 FROM actor
 WHERE last_name LIKE '%GEN%';
 
 -- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order.
 
 SELECT last_name AS `Last Name`, first_name AS `First Name`
 FROM actor
 WHERE last_name LIKE '%LI%';
 
 -- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China.
 
 SELECT country_id AS `Country ID`, country AS `Country`
 FROM country
 WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
 
 -- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
 
 ALTER TABLE actor
 ADD COLUMN middle_name TEXT
 AFTER first_name;
 
 -- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
 
 ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

-- 3c. Now delete the middle_name column.

ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name AS `Last Name`, COUNT(last_name) AS `Count of Last Name`
FROM actor
GROUP BY last_name;
 
 -- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
 -- This way feels unnecessarily complicated, but a simple WHERE statement wasn't working; should try to clean up later.
  SELECT temp.`Last Name`, temp.`Count of Last Name`
  FROM
 (
 SELECT last_name AS `Last Name`, COUNT(last_name) AS `Count of Last Name`
FROM actor
GROUP BY last_name
) AS temp
WHERE `Count of Last Name` > 1;
 
 -- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO', last_name = 'WILLIAMS'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. If the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO.

UPDATE actor
SET first_name = CASE
WHEN first_name = 'HARPO' THEN 'GROUCHO'
ELSE 'MUCHO GROUCHO'
END;
 
 -- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
 -- Probably not the way I'm supposed to do this
 select TABLE_SCHEMA
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='address';
 
 -- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address.
 
 SELECT staff.first_name, staff.last_name, address.address
 FROM staff JOIN address
 ON address.address_id = staff.address_id;
 
 -- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
 
 SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS `Amount Rung Up`
 FROM staff JOIN payment
 ON staff.staff_id = payment.staff_id
 GROUP BY staff.staff_id;
 
 -- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
 
 SELECT film.title, COUNT(film_actor.actor_id) AS `Number of Actors`
 FROM film INNER JOIN film_actor
 ON film.film_id = film_actor.film_id
 GROUP BY film.title;
 
 -- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
 
 SELECT film.title, temp.`Number of Copies`
 FROM film JOIN (
 SELECT film_id, COUNT(store_id) AS `Number of Copies`
 FROM inventory
 GROUP BY film_id ) AS temp
 ON film.film_id = temp.film_id
 WHERE film.title = 'HUNCHBACK IMPOSSIBLE';
 
 -- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
 
 SELECT customer.first_name, customer.last_name, temp.`Paid`
 FROM customer JOIN (
 SELECT customer_id, SUM(amount) AS `Paid`
 FROM payment
 GROUP BY customer_id ) AS temp
 ON customer.customer_id = temp.customer_id;
 
 -- 7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
 
 SELECT temp.title, temp.name AS 'Language'
 FROM
 (
 SELECT film.title, `language`.name 
 FROM film JOIN `language` 
 ON film.language_id = `language`.language_id) AS temp
 WHERE temp.title LIKE 'K%' OR temp.title LIKE 'Q%';
 
 -- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
 
 SELECT temp.title, CONCAT(actor.first_name, ' ', actor.last_name) AS `Actor Name`
 FROM actor JOIN
 (
 SELECT film.title, film_actor.actor_id
 FROM film JOIN film_actor ON film.film_id = film_actor.film_id
 WHERE film.title = 'ALONE TRIP') AS temp
 ON temp.actor_id = actor.actor_id;
 
 -- 7c. You need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
 
 SELECT temp2.customer_name, temp2.email, country.country
 FROM country JOIN
 (
 SELECT temp1.customer_name, temp1.email, city.country_id
 FROM city JOIN
 (
 SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, customer.email AS email, address.city_id AS city_id
 FROM customer JOIN address
 ON customer.address_id = address.address_id) as temp1
 ON temp1.city_id = city.city_id ) AS temp2
 ON temp2.country_id = country.country_id
 WHERE country.country = 'Canada';
 
 -- 7d. Identify all movies categorized as famiy films.
 
 SELECT temp.title, category.name
 FROM category JOIN
 (
 SELECT film.title AS title, film_category.category_id AS category_id
 FROM film JOIN film_category
 ON film.film_id = film_category.film_id) AS temp
 ON category.category_id = temp.category_id
 WHERE category.name = 'Family';
 
 -- 7e. Display the most frequently rented movies in descending order.
 
 SELECT title, rental_rate
 FROM film
 ORDER BY rental_rate DESC;
 
 -- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT staff.store_id AS store_id, SUM(payment.amount) AS amount
FROM payment JOIN staff
ON payment.staff_id = staff.staff_id
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT temp2.store_id, temp2.city AS city, country.country AS country
FROM country JOIN
(
SELECT temp1.store_id AS store_id, city.city AS city, city.country_id AS country_id
FROM city JOIN
(
SELECT store.store_id AS store_id, address.city_id AS city_id
FROM store JOIN address
ON store.address_id = address.address_id) AS temp1
) AS temp2
ON temp2.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT category.name AS category_name, SUM(temp3.amount) AS amount
FROM category JOIN(
SELECT temp2.amount AS amount, film_category.category_id AS category_id
FROM film_category JOIN
(
SELECT temp1.amount AS amount, inventory.film_id AS film_id
FROM inventory JOIN (
SELECT payment.amount AS amount, rental.inventory_id AS inventory_id
FROM payment JOIN rental
ON payment.rental_id = rental.rental_id ) AS temp1
ON temp1.inventory_id = inventory.inventory_id) AS temp2
ON temp2.film_id = film_category.film_id) AS temp3
ON temp3.category_id = category.category_id
GROUP BY category_name
ORDER BY amount DESC LIMIT 5;

-- 8a. You would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 

CREATE VIEW `Top 5 Grossing Genres` AS
SELECT category.name AS category_name, SUM(temp3.amount) AS amount
FROM category JOIN(
SELECT temp2.amount AS amount, film_category.category_id AS category_id
FROM film_category JOIN
(
SELECT temp1.amount AS amount, inventory.film_id AS film_id
FROM inventory JOIN (
SELECT payment.amount AS amount, rental.inventory_id AS inventory_id
FROM payment JOIN rental
ON payment.rental_id = rental.rental_id ) AS temp1
ON temp1.inventory_id = inventory.inventory_id) AS temp2
ON temp2.film_id = film_category.film_id) AS temp3
ON temp3.category_id = category.category_id
GROUP BY category_name
ORDER BY amount DESC LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM `Top 5 Grossing Genres`;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW `Top 5 Grossing Genres`;







 
 
 
 
 
 
 
 
 
 
 
 
 
 
