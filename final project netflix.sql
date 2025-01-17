-- -- -- NETFLIX PROJECT -- -- --

-- create table netflix

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(6),
	type    VARCHAR(10),
	title	VARCHAR(150),
	director VARCHAR(208),
	casts	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(50),
	release_year	INT,
	rating	VARCHAR(10),
	duration	VARCHAR(15),
	listed_in	VARCHAR(100),
	description VARCHAR(250)
);


SELECT *
FROM netflix;

SELECT COUNT(*) AS total_rows
FROM netflix;

-- Q1 Count the total number of movies and TV shows in the dataset.

SELECT type,COUNT(*) AS total
FROM netflix
GROUP BY type;


-- Q2 Identify the most common rating for movies and TV shows.

SELECT type,rating,total_rating
FROM(
SELECT 
	   type,
       rating,
	   COUNT(*) AS total_rating,
	   RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY type,rating
ORDER BY 4
LIMIT 2);


-- Q3  List all movies that were released in 2019.

SELECT title
FROM netflix 
WHERE 
	release_year = 2019 
AND 
	type = 'Movie';

-- Q4 Identify the top 5 countries with the most content available on Netflix.

SELECT TRIM(UNNEST(STRING_TO_ARRAY(country,','))) AS new_country, 
                                                                  
												                   
       COUNT(*) AS total_content                                  
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q5 Identify the longest movie based on its duration.

SELECT title,
       MAX(CAST(REPLACE(duration, ' min', '') AS INTEGER)) AS duration_in_minutes
FROM 
    netflix
WHERE type = 'Movie' AND duration IS NOT NULL
GROUP BY title
ORDER BY 2 DESC
LIMIT 1;	

-- Q6 Retrieve the total number of movies directed by Steven Spielberg and list all the movies he directed in two separate queries.

-- Count the number of movies directed by Steven Spielberg
SELECT COUNT(title) AS movies_of_S_Spielberg
FROM netflix
WHERE director = 'Steven Spielberg'
GROUP BY director;

-- List all movies directed by Steven Spielberg
SELECT title
FROM netflix
WHERE director = 'Steven Spielberg';


-- Q7 List all movies and TV shows directed by Rajiv Chilaka, along with the count for each type.

SELECT director,type,COUNT(title)
FROM Netflix
WHERE director LIKE '%Rajiv Chilaka%'
GROUP BY director,type
ORDER BY 2 DESC;


-- Q8  List all TV shows that have more than 5 seasons.

SELECT title, 
       duration
FROM netflix      
WHERE 
	  type ='TV Show' 
AND
	  CAST(SPLIT_PART(duration,' ',1) AS INT) >=5;



--Q9 Count the total number of movies for each genre.

SELECT 
	   UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
	   COUNT(title) AS total_content,
	   type
FROM netflix
GROUP BY 1,3
ORDER BY 3,2 DESC;

--Q10 Determine the number of movies and TV shows released each year in the United States.

SELECT release_year,COUNT(type) AS total_content
FROM netflix
WHERE country = 'United States'
GROUP BY country,release_year
ORDER BY 1 DESC;


--Q11 Calculate the average percentage of content released in the United States for each year.

WITH C AS (WITH C AS(
SELECT EXTRACT(YEAR FROM(TO_DATE(date_added,'Month DD, YYYY'))) AS year,
	   COUNT(*) AS total_content 
FROM netflix
WHERE country = 'United States' 
GROUP BY 1
)
SELECT year,
ROUND(total_content::numeric/(SELECT COUNT(*) FROM netflix
                        WHERE country = 'United States')*100,2) AS average_year
FROM C;


--Q12 List all movies categorized as documentaries.

SELECT title,listed_in AS genre
FROM netflix
WHERE 
	type = 'Movie' 
AND
	listed_in ILIKE '%Documentaries%';
	
	
--Q13 Retrieve all content entries that do not have a specified director.

SELECT *
FROM netflix
WHERE director IS NULL;

--Q14 In how many movies actor Salman Khan appeared in the last 15 years

SELECT *
FROM netflix
WHERE 
	CASTS ILIKE '%Salman Khan%'
AND 
    release_year > EXTRACT(YEAR FROM CURRENT_DATE)-15
;


--Q15 Identify the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT
		UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
		COUNT(title)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


--Q16 Categorize movies as 'BAD' if their description contains the words 'bad' or 'violence', and as 'GOOD' otherwise.
--    Count the total number of movies in each category.

WITH C AS (
SELECT type,
	   title,
	   country,
       CASE 
           WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'BAD'
           ELSE 'GOOD'
       END AS content_rating
FROM netflix
)
SELECT content_rating,
	   COUNT(*) AS total_content
FROM C
GROUP BY content_rating;
    



