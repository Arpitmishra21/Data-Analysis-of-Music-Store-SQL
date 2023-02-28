-- Q1. Who is the most senior most employee based on job title?

select * from employee
order by levels desc
limit 1

-- Q2. Which countries have the most invoices?

select count(*) as c, billing_country from invoice
group by billing_country
order by c desc

-- Q3. What are the top 3 values of total invoices?

select * from invoice
order by total desc
limit 3
-- Q4. Which city has the best customer? We would like to throw a music festival in the city we made the most money.

select sum(total) as invoice_total,billing_city from invoice
group by billing_city
order by invoice_total desc
limit 1

-- Q5. Who is the best customer? The customer who has spent most money will be declared as best customer?

select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

-- Q6. Write a query to return the email,first_name, last_name & genre of all music listner. 
-- return your list orderd alphabetically by email starting with a

select  distinct email, first_name,last_name 
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id IN 
(select track_id from track join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock')
order by email;

-- Q7.Lets invite the artist who have written the most rock music in our dataset. 
-- write a query that returns the artist name and total track count of the top 10 rock bands.

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track 
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name Like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;

-- Q8.Return all the track names that have a song length longer than the average song length. 
-- return the name and milliseconds for each track.order by the song length with the longest song listed first  

select name,milliseconds from track where milliseconds > (select avg(milliseconds) as avg_milliseconds from track)
order by milliseconds desc;

-- Q9. Find how much amount spent by each customer on artists? write a sql query to find artist name,totall spent
 
 with best_selling_artist as(
 select artist.artist_id as artist_id, artist.name as artist_name,
	 sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	 from invoice_line
	 join track on track.track_id=invoice_line.track_id
	 join album on album.album_id=track.album_id
	 join artist on artist.artist_id = album.artist_id
	 group by 1
	 order by 3 desc
	 limit 1
)

select c.customer_id, c.first_name, c.last_name, bsa.artist_name, sum(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on  t.track_id=il.track_id
join album alb on alb.album_id=t.album_id
join best_selling_artist bsa on bsa.artist_id=alb.artist_id
group by 1,2,3,4
order by 5 desc;
 
 
 
 
