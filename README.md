
# Netflix Content Analysis Project

![netflix_logo](https://github.com/StefanosStefanidis93/Netflix_Sql_Project/blob/main/logo.png)


This project contains a series of SQL queries that analyze various aspects of Netflix content. The goal is to perform data analysis and extract insights from the Netflix dataset, specifically focusing on movies and TV shows. Each query is designed to explore different attributes of the content, such as genres, directors, release years, and more.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Objectives
- **Data Exploration**: Understand the distribution of content types (Movies and TV Shows) on Netflix.
- **Content Analysis**: Analyze different aspects of the content, such as genres, release years, countries, and the average duration.
- **Content Categorization**: Categorize content based on specific keywords in the description and analyze its distribution.
- **Director and Actor Analysis**: Explore the work of specific directors and actors in Netflix content.
- **Country-Specific Analysis**: Analyze Netflix content for specific countries (e.g., USA, India).

## SQL Queries and Analysis

### Q1: Count the Total Number of Movies and TV Shows in the Dataset
```sql
SELECT type, COUNT(*) AS total
FROM netflix
GROUP BY type;
```

### Q2: Retrieve the Most Common Rating for Movies and TV Shows
```sql
SELECT type, rating, COUNT(*) AS total_rating
FROM netflix
GROUP BY type, rating
ORDER BY total_rating DESC;
```

### Q3: List All Movies Released in 2019
```sql
SELECT title
FROM netflix 
WHERE release_year = 2019
AND type = 'Movie';
```

### Q4: Identify the Top Countries with the Most Content on Netflix
```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS new_country, 
       COUNT(*) AS total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;
```

### Q5: Find the Longest Movie in the Dataset
```sql
SELECT title,
       MAX(CAST(REPLACE(duration, ' min', '') AS INTEGER)) AS duration_in_minutes
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
GROUP BY title
ORDER BY duration_in_minutes DESC
LIMIT 1;
```

### Q6: Count the Number of Movies Directed by Steven Spielberg, and Break Them Down by Content Type
```sql
SELECT director, type, COUNT(title)
FROM netflix
WHERE director LIKE '%Steven Spielberg%'
GROUP BY director, type
ORDER BY type DESC;
```

### Q7: Count the Number of Movies and TV Shows Directed by Rajiv Chilaka, and Break Them Down by Content Type
```sql
SELECT director, type, COUNT(title)
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'
GROUP BY director, type
ORDER BY type DESC;
```

### Q8: List TV Shows with More Than 5 Seasons
```sql
SELECT title,
       duration
FROM netflix      
WHERE type = 'TV Show' 
AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;
```

### Q9: Find the Total Number of Movies for Each Genre
```sql
SELECT 
       UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
       COUNT(title) AS total_content,
       type
FROM netflix
WHERE type = 'Movie'
GROUP BY genre, type
ORDER BY total_content DESC;
```

### Q10: Count the Number of Movies and TV Shows Released Each Year for the United States
```sql
SELECT release_year, COUNT(type) AS total_content
FROM netflix
WHERE country = 'United States'
GROUP BY release_year, type
ORDER BY release_year DESC;
```

### Q11: Find the Average Content Released in the United States Each Year
```sql
WITH C AS (
    SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
           COUNT(*) AS total_content
    FROM netflix
    WHERE country = 'United States'
    GROUP BY year
)
SELECT year,
       ROUND(total_content::numeric / (SELECT COUNT(*) FROM netflix 
                                         WHERE country = 'United States') * 100, 2) AS average_year
FROM C;
```

### Q12: List All Movies That Are Documentaries
```sql
SELECT title, listed_in AS genre
FROM netflix
WHERE type = 'Movie'
AND listed_in ILIKE '%Documentaries%';
```

### Q13: Find All Content Without a Director
```sql
SELECT *
FROM netflix
WHERE director IS NULL;
```

### Q14: Categorize Movies Based on Descriptions Containing Keywords and Count Them
```sql
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
```

### Q15: Find the Top 10 Actors Who Played in the Highest Number of Movies in India
```sql
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
       COUNT(title)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

### Q16: Categorize Movies with 'Bad' and 'Violence' as "Bad" and the Rest as "Good"
```sql
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
```

## Findings

 1. Content Distribution:
 The dataset contains a balanced distribution between Movies and TV Shows.
 The most common content type on Netflix is Movies, and they make up a significant portion of the catalog.

 2. Genre Insights:
 The genres of Movies vary significantly across different countries.
 The most frequently listed genres are Drama, Action, and Comedy.

 3. Director Contributions:
 Some directors, such as Steven Spielberg, have contributed significantly to Netflix's content.
 Spielberg's content is primarily in the Movie category.

 4. Top Countries:
 The United States holds the largest share of Netflix content, with other countries offering diverse content.
 The "Top Countries" analysis highlights the global reach of Netflix.

 5. TV Show Analysis:
 TV Shows with more than 5 seasons are rare, yet they represent a significant portion of long-running series.
 This analysis shows that long-running series are a notable part of Netflix's offerings.

 6. Content Length:
 The longest movie in the dataset is significantly longer than the average movie, demonstrating that outliers in movie length exist.
 This provides insight into how movies vary in duration, with some being considerably longer than others.

## Conclusions

 1. Netflix's content catalog is highly diverse, offering Movies and TV Shows across multiple countries and genres.
    
 2. Movies dominate Netflix's offerings, with popular genres like Drama, Comedy, and Action frequently represented.
    
 3. Directors like Steven Spielberg have played a significant role in contributing Movies to Netflix, cementing their influence in the content catalog.
    
 4. TV Shows with more than 5 seasons, though rare, represent an essential part of long-running series available on Netflix.
    
 5. Netflix's focus on countries like the United States highlights a large portion of its global reach, with content from various countries and genres.
    
 6. By analyzing Netflix's catalog, we gain valuable insights into the trends and preferences within the platform, informing content creation and viewer recommendations.

