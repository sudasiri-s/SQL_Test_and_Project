/**
Find the ten best-selling games. The output should contain all the columns in the game_sales table and be sorted 
by the games_sold column in descending order. Save the output as best_selling_games.
**/
-- best_selling_games
SELECT * 
FROM game_sales
ORDER BY games_sold DESC
LIMIT 10;


/**Find the ten years with the highest average critic score, where at least four games were released (to ensure a good sample size). 
Return an output with the columns year, num_games released, and avg_critic_score. The avg_critic_score should be rounded to 2 decimal places. 
The table should be ordered by avg_critic_score in descending order. Save the output as critics_top_ten_years. 
Do not use the critics_avg_year_rating table provided; this has been provided for your third query.
 **/
-- critics_top_ten_years
SELECT 
	year, 
	COUNT(public.game_sales.name) AS num_games, 
	ROUND(AVG(critic_score),2) AS avg_critic_score 
FROM game_sales
INNER JOIN reviews ON game_sales.name = reviews.name
GROUP BY year
HAVING COUNT(game_sales.name) >= 4
ORDER BY ROUND(AVG(critic_score),2) DESC
LIMIT 10;


/** Find the years where critics and users broadly agreed that the games released were highly rated. Specifically, 
 * return the years where the average critic score was over 9 OR the average user score was over 9. 
 * The pre-computed average critic and user scores per year are stored in users_avg_year_rating and critics_avg_year_rating tables respectively. 
 * The query should return the following columns: year, num_games, avg_critic_score, avg_user_score, and diff. 
 * The diff column should be the difference between the avg_critic_score and avg_user_score. 
 * The table should be ordered by the year in ascending order, save this as a DataFrame named golden_years.
**/
-- golden_years
SELECT 
	critics_avg_year_rating.year AS year, 
	critics_avg_year_rating.num_games AS num_games,
	avg_critic_score,
	avg_user_score,
	avg_user_score - avg_critic_score AS diff
FROM critics_avg_year_rating 
INNER JOIN users_avg_year_rating ON critics_avg_year_rating.year = users_avg_year_rating.year
WHERE (users_avg_year_rating.avg_user_score > 9 OR critics_avg_year_rating.avg_critic_score > 9)
ORDER BY critics_avg_year_rating.year
LIMIT 10;