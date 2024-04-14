/*
sql challenges
1. Who are the first 10 authors ordered by date_of_birth?
2. What is the sales total for the author named “Lorelai Gilmore”?
3. What are the top 10 performing authors, ranked by sales revenue?

postgre password: IKik1234
port: 5432

*/
CREATE DATABASE krikeydata
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE TABLE authors (
id serial PRIMARY KEY,
name text,
email text,
date_of_birth timestamp
);
CREATE TABLE books (
id serial PRIMARY KEY,
author_id integer REFERENCES authors (id),
isbn text,
);
CREATE TABLE sale_items (
id serial PRIMARY KEY,
book_id integer REFERENCES books (id),
customer_name text,
item_price money,
quantity integer
);

INSERT INTO authors (name, email, date_of_birth) VALUES ('Lorelai Gilmore', 'lorelaiLovesCoffee@gmail.com', '1980-06-22 11:09:08'), ('Rory Gilmore', 'roryLovesToRead@gmail.com', '1996-10-22 06:09:08'), ('Luke Danes', 'thisemaildoesnotexist@gmail.com', '1980-03-22 06:11:20'), ('Sookie St James', 'sookieLovesCooking@gmail.com', '1981-08-22 04:30:20'), ('Jess Mariano', 'jessIsAWriter@gmail.com', '1996-04-04 04:04:04'), ('Lane Kim', 'laneLovesMusic@gmail.com', '1995-11-2 07:20:02'), ('Logan Huntzberger', 'LoganHatesHisJob@gmail.com', '1994-07-01 10:11:20'), ('Paris Geller', 'parisIsADoc@gmail.com', '1996-09-15 20:11:18'), ('Emily Gilmore', 'emilygilmore@gmail.com', '1960-01-26 06:06:06'), ('Richard Gilmore', 'richardgilmore@gmail.com', '1960-02-14 06:06:06') RETURNING *;

INSERT INTO books (author_id, isbn) VALUES (21, 123), (13, 132), (16, 213), (16, 214), (12, 311), (12, 312), (14, 713), (15, 255), (17, 918), (18, 718), (19, 515), (20, 616) RETURNING *;

INSERT INTO sale_items (book_id, customer_name, item_price, quantity) VALUES  (1, 'ishu', 20, 1), (2, 'caroline', 15, 2), (3, 'anika', 20, 3), (4, 'lindsey', 10, 1), (5, 'emily', 30, 2), (6, 'shannon', 5, 4), (7, 'robbie', 18, 2), (8, 'deets', 16, 1), (9, 'jun', 10, 2), (10, 'alena', 20, 4) RETURNING *;

SELECT *
FROM authors 
ORDER BY date_of_birth;

SELECT item_price*quantity as sales_total
FROM sale_items
WHERE book_id = 
(SELECT MAX(id)
FROM books
WHERE author_id = (SELECT MAX(id) FROM authors WHERE authors.name = 'Lorelai Gilmore'));

SELECT a.name, a.email, s.item_price*s.quantity as revenue
FROM sale_items s
join books b
on b.id = s.book_id
join authors a
on a.id = b.author_id
group by a.name, a.email, revenue
order by revenue DESC;