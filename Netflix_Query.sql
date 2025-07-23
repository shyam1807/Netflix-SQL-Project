-- Netflix Project

CREATE TABLE netflix1
(
show_id	VARCHAR(6),
type    VARCHAR(10),
title	VARCHAR(150),
director VARCHAR(208),	
casts	 VARCHAR(1000),
country	  VARCHAR(150),
date_added	VARCHAR(50),
release_year INT,
rating	VARCHAR(10),
duration	VARCHAR(15),
listed_in	VARCHAR(100),
description VARCHAR(250)
);

SELECT * FROM netflix1;

SELECT COUNT(*) as total_content FROM netflix1;

SELECT DISTINCT type FROM netflix1;

SELECT * FROM netflix1;

-- 15 Business Problems

-- 1. Count the number of Movies vs TV Shows

SELECT
      type,
	  count(*) as total_count
  FROM netflix1
  GROUP BY TYPE

  -- 2. find the most common rating for movies and TV Shows

  SELECT 
        type,
		rating
FROM		

 (
  SELECT 
       type,
	   rating,
	   count(*),
	   RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	   
	   -- MAX(rating)
	  FROM netflix1
	  GROUP BY 1, 2) as t1
	  -- ORDER BY 1, 3 DESC

	  WHERE ranking = 1

3. List all movies released in a specific year(e.g 2020)

SELECT * FROM netflix1

 WHERE 
 
       type = 'Movie'
	   AND
       release_year= 2020

	   4. find the top 5 countries with the most content on netflix1

	   SELECT 
	        UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
			COUNT(show_id) as total_content
	FROM netflix1
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5

5. Identify the longest movies

SELECT * FROM netflix1
WHERE 
    type='Movie'
	AND 
	duration=(SELECT MAX(duration) FROM netflix1)


6. find content added in the last 5 years

SELECT
     
* FROM netflix1
WHERE 
     TO_DATE(date_added, 'Month DD YYYY') >=CURRENT_DATE - INTERVAL '5 years'



7. find all the movies/TV shows by director 'Rajiv Chilaka'


SELECT * FROM netflix1
WHERE director= 'Rajiv Chilaka'


-- 8. list all tv shows with more than 5 season


SELECT
	   *
FROM netflix1
WHERE
     type = 'TV Shows'  
	 AND
     SPLIT_PART(duration, ' ' ,1)::numeric > 5


9. Count the number of content items in each genre

SELECT
	 UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	 COUNT(show_id)
FROM netflix1
GROUP BY 1


10. find each year and the avg numbers of content release by india on netflix return top 5 yearwith highst avg content release.


SELECT  
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	  COUNT(*), as yearly_content
	  round(
	  COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix1 WHERE country = 'India')::numeric *100,2) as avg_content_per_year
FROM netflix1
WHERE country = 'India'
GROUP BY 1


11. list all movies that are documentaries




SELECT * FROM netflix1
WHERE
     listed_in ILIKE'%documentaries%'


12. find all content without a director

SELECT * FROM netflix1
WHERE 
     director IS NULL

13. find how many movies actor 'Salman Khan' appears in last 10 years.


SELECT * FROM netflix1
WHERE 
     casts ILIKE '%Salman Khan%'
	 AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


14. Find the top 10 actor who have appeared in the highest number of movies produced in india.


SELECT 
UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
COUNT(*) as total_content
FROM netflix1
WHERE COUNTRY ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESc
LIMIT 10


15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

WITH new_table
AS
(
SELECT 
*,
    CASE
    WHEN 
	     description ILIKE '%KILL%' OR
		 description ILIKE '%violence%' THEN 'BAD CONTENT'
		 ELSE 'GOOD CONTENT'
END category
FROM netflix1
)
SELECT 
     category,
	 COUNT(*) as total_content
	 FROM new_table
	 GROUP BY 1
