USE sakila;

-- From the sakila database

-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name
FROM actor;


-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
CREATE TABLE actor_new2 AS SELECT * FROM actor;

SELECT first_name, last_name, CONCAT(first_name, " ", last_name) AS 'name_first_last'
FROM actor_new2;


-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name="Joe";


-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';


-- 2c. Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order:
SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;


-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN
(
	"Afghanistan", "Bangladesh", "China"
);


-- 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. 
-- Hint: you will need to specify the data type.
ALTER TABLE actor
ADD COLUMN `middle_name` VARCHAR(100) AFTER `first_name`;
-- To check out the changes of the table actor:
SELECT * FROM actor;


-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor
MODIFY middle_name BLOB;


-- 3c. Now delete the `middle_name` column.
ALTER TABLE actor
DROP COLUMN middle_name;
-- To check out the changes of the table actor:
SELECT * FROM actor;


-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(actor_id) AS number_lastnames
FROM actor
GROUP BY last_name;


-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name, COUNT(actor_id) AS number_lastnames
FROM actor
GROUP BY last_name
HAVING number_lastnames > 1;


-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";
-- Checking the changes
SELECT * FROM actor
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";


-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, 
-- if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, 
-- as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

SELECT * FROM actor
WHERE actor_id = 172;

SET SQL_SAFE_UPDATES = 0;

UPDATE actor
SET first_name = CASE
		WHEN (last_name="WILLIAMS" AND first_name="HARPO") THEN "GROUCHO"
		WHEN (last_name="WILLIAMS" AND first_name="GROUCHO") THEN "MUCHO GROUCHO"
END
WHERE actor_id = 172;

SELECT * FROM actor;


-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;


-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`:
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON staff.address_id=address.address_id;


-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
-- Use tables `staff` and `payment`.
SELECT staff.staff_id, staff.first_name, staff.last_name, COUNT(payment.payment_id) AS "Rung Up Total"
FROM staff
JOIN payment ON staff.staff_id=payment.staff_id
WHERE payment.payment_date LIKE "2005-08%"
GROUP BY staff.staff_id;


-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables `film_actor` and `film`. Use inner join.
SELECT film.film_id, film.title, COUNT(film_actor.actor_id) AS Total_Actors
FROM film
JOIN film_actor ON film.film_id=film_actor.film_id
GROUP BY film.title;


-- 6d. How many copies of the film `Hunchback Impossible` 
-- exist in the inventory system?
SELECT *
FROM inventory;

SELECT film.film_id, film.title, COUNT(inventory.film_id) AS Total_copies
FROM film
JOIN inventory ON film.film_id=inventory.film_id
WHERE film.title="Hunchback Impossible";


-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, 
-- list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount) AS Total_paid
FROM customer
JOIN payment ON customer.customer_id=payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name, first_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters `K` and `Q` 
-- have also soared in popularity. Use subqueries to display the titles of movies 
-- starting with the letters `K` and `Q` whose language is English.


