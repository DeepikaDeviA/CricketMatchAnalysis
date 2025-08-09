-- select databse
USE cricket_data;

-- data cleaning
-- removing duplicates for ipl data
-- Updating team_1 values

UPDATE ipl_match_summary SET team_1 = 'Rising Pune Supergiant' WHERE team_1 = 'Rising Pune Supergiants';
UPDATE ipl_match_summary SET team_1 = 'Royal Challengers Bengaluru' WHERE team_1 = 'Royal Challengers Bangalore';
UPDATE ipl_match_summary SET team_1 = 'Delhi Capitals' WHERE team_1 = 'Delhi Daredevils';
UPDATE ipl_match_summary SET team_1 = 'Punjab Kings' WHERE team_1 = 'Kings XI Punjab';

-- Updating team_2 values
UPDATE ipl_match_summary SET team_2 = 'Rising Pune Supergiant' WHERE team_2 = 'Rising Pune Supergiants';
UPDATE ipl_match_summary SET team_2 = 'Royal Challengers Bengaluru' WHERE team_2 = 'Royal Challengers Bangalore';
UPDATE ipl_match_summary SET team_2 = 'Delhi Capitals' WHERE team_2 = 'Delhi Daredevils';
UPDATE ipl_match_summary SET team_2 = 'Punjab Kings' WHERE team_2 = 'Kings XI Punjab';

-- Updating winner values
UPDATE ipl_match_summary SET winner = 'Rising Pune Supergiant' WHERE winner = 'Rising Pune Supergiants';
UPDATE ipl_match_summary SET winner = 'Royal Challengers Bengaluru' WHERE winner = 'Royal Challengers Bangalore';
UPDATE ipl_match_summary SET winner = 'Delhi Capitals' WHERE winner = 'Delhi Daredevils';
UPDATE ipl_match_summary SET winner = 'Punjab Kings' WHERE winner = 'Kings XI Punjab';

#1. Who are the top 10 male batsmen in ODI cricket with the highest strike rate (minimum 60 balls faced)?
SELECT 
    ob.batter AS player_name,
    SUM(ob.runs_batter) AS total_runs,
    COUNT(*) AS balls_faced,
    ROUND(SUM(ob.runs_batter) / COUNT(*) * 100, 2) AS strike_rate
FROM odi_ball_by_ball ob
JOIN odi_match_summary om ON ob.match_id = om.match_id
WHERE om.gender = 'male' AND ob.runs_batter != 'NA'
GROUP BY ob.batter
HAVING balls_faced >= 60
ORDER BY strike_rate DESC
LIMIT 10;



#2. Who are the top 10 highest run-scorers across all formats (ODI, T20, Test, IPL)?
SELECT batter AS player_name, SUM(runs_batter) AS total_runs
FROM (
    SELECT batter, runs_batter FROM odi_ball_by_ball
    UNION ALL
    SELECT batter, runs_batter FROM t20_ball_by_ball
    UNION ALL
    SELECT batter, runs_batter FROM test_ball_by_ball
    UNION ALL
    SELECT batter, runs_batter FROM ipl_ball_by_ball
) AS combined_runs
GROUP BY player_name
ORDER BY total_runs DESC
LIMIT 10;

#3. Which 5 male players have scored the most half-centuries across all formats?

SELECT player_name,
       COUNT(CASE WHEN total_runs BETWEEN 50 AND 99 THEN 1 END) AS half_centuries
       
FROM (
    
    SELECT ob.match_id, ob.batter AS player_name,
           SUM(ob.runs_batter) AS total_runs
    FROM odi_ball_by_ball ob
    JOIN odi_match_summary om ON ob.match_id = om.match_id
    WHERE om.gender = 'male'
    GROUP BY ob.match_id, player_name

    UNION ALL

    SELECT tb.match_id, tb.batter AS player_name,
           SUM(tb.runs_batter) AS total_runs
    FROM test_ball_by_ball tb
    JOIN test_match_summary tm ON tb.match_id = tm.match_id
    WHERE tm.gender = 'male'
    GROUP BY tb.match_id, player_name

    UNION ALL

    SELECT t20.match_id, t20.batter AS player_name,
           SUM(t20.runs_batter) AS total_runs
    FROM t20_ball_by_ball t20
    JOIN t20_match_summary t20m ON t20.match_id = t20m.match_id
    WHERE t20m.gender = 'male'
    GROUP BY t20.match_id, player_name

    UNION ALL

    SELECT ip.match_id, ip.batter AS player_name,
           SUM(ip.runs_batter) AS total_runs
    FROM ipl_ball_by_ball ip
    JOIN ipl_match_summary ipm ON ip.match_id = ipm.match_id
    WHERE ipm.gender = 'male'
    GROUP BY ip.match_id, player_name
) AS innings_scores
GROUP BY player_name
ORDER BY half_centuries DESC LIMIT 5;

#4. Who are the top 5 male batsmen with the most centuries across all formats?

SELECT player_name,
       COUNT(CASE WHEN total_runs >= 100 THEN 1 END) AS centuries
FROM (
    
    SELECT ob.match_id, ob.batter AS player_name,
           SUM(ob.runs_batter) AS total_runs
    FROM odi_ball_by_ball ob
    JOIN odi_match_summary om ON ob.match_id = om.match_id
    WHERE om.gender = 'male'
    GROUP BY ob.match_id, player_name

    UNION ALL


    SELECT tb.match_id, tb.batter AS player_name,
           SUM(tb.runs_batter) AS total_runs
    FROM test_ball_by_ball tb
    JOIN test_match_summary tm ON tb.match_id = tm.match_id
    WHERE tm.gender = 'male'
    GROUP BY tb.match_id, player_name

    UNION ALL

    SELECT t20.match_id, t20.batter AS player_name,
           SUM(t20.runs_batter) AS total_runs
    FROM t20_ball_by_ball t20
    JOIN t20_match_summary t20m ON t20.match_id = t20m.match_id
    WHERE t20m.gender = 'male'
    GROUP BY t20.match_id, player_name

    UNION ALL

    SELECT ip.match_id, ip.batter AS player_name,
           SUM(ip.runs_batter) AS total_runs
    FROM ipl_ball_by_ball ip
    JOIN ipl_match_summary ipm ON ip.match_id = ipm.match_id
    WHERE ipm.gender = 'male'
    GROUP BY ip.match_id, player_name
) AS innings_scores

GROUP BY player_name
ORDER BY centuries DESC LIMIT 5;

#5.Which 5 male batters have the most ducks across all cricket formats?
select player_name,
COUNT(CASE WHEN total_runs = 0 THEN 1 END) as duck_out
from(
select batter as player_name, sum(runs_batter) as total_runs
from odi_ball_by_ball 
group by match_id,player_name

UNION ALL
select batter as player_name, sum(runs_batter) as total_runs
from t20_ball_by_ball 
group by match_id,player_name

UNION ALL
select batter as player_name, sum(runs_batter) as total_runs
from ipl_ball_by_ball 
group by match_id,player_name

UNION ALL
select batter as player_name, sum(runs_batter) as total_runs
from test_ball_by_ball 
group by match_id,player_name
) as ducks
group by player_name
Order by duck_out DESC LIMIT 5;

#6. Who are the top 10 bowlers with the most wickets across all formats in men's cricket?
SELECT player_name,
       SUM(wickets_in_match) AS total_wickets
FROM (
    SELECT match_id, bowler AS player_name,
           COUNT(*) AS wickets_in_match
    FROM odi_ball_by_ball
    WHERE wicket_kind NOT IN ('nan', 'retired', 'run out', 'obstructing the field')
    GROUP BY match_id, bowler

    UNION ALL

    SELECT match_id, bowler AS player_name,
           COUNT(*) AS wickets_in_match
    FROM t20_ball_by_ball
    WHERE wicket_kind NOT IN ('nan', 'retired', 'run out', 'obstructing the field')
    GROUP BY match_id, bowler

    UNION ALL

    SELECT match_id, bowler AS player_name,
           COUNT(*) AS wickets_in_match
    FROM test_ball_by_ball
    WHERE wicket_kind NOT IN ('nan', 'retired', 'run out', 'obstructing the field')
    GROUP BY match_id, bowler

    UNION ALL

    SELECT match_id, bowler AS player_name,
           COUNT(*) AS wickets_in_match
    FROM ipl_ball_by_ball
    WHERE wicket_kind NOT IN ('nan', 'retired', 'run out', 'obstructing the field')
    GROUP BY match_id, bowler
) AS all_matches
GROUP BY player_name
ORDER BY total_wickets DESC
LIMIT 10;

#7. Top Wicket Taker in Each Format
#odi
SELECT bowler AS player_name,
       COUNT(*) AS total_wickets
FROM odi_ball_by_ball
WHERE wicket_kind NOT IN ('NA', 'nan', 'retired', 'retired hurt', 'obstructing the field')
GROUP BY player_name
ORDER BY total_wickets DESC
LIMIT 1;

#t20
SELECT bowler AS player_name,
       COUNT(*) AS total_wickets
FROM t20_ball_by_ball
WHERE wicket_kind NOT IN ('NA', 'nan', 'retired', 'retired hurt', 'obstructing the field')
GROUP BY player_name
ORDER BY total_wickets DESC
LIMIT 1;

#test
SELECT bowler AS player_name,
       COUNT(*) AS total_wickets
FROM test_ball_by_ball
WHERE wicket_kind NOT IN ('NA', 'nan', 'retired', 'retired hurt', 'obstructing the field')
GROUP BY player_name
ORDER BY total_wickets DESC
LIMIT 1;

#ipl
SELECT bowler AS player_name,
       COUNT(*) AS total_wickets
FROM ipl_ball_by_ball
WHERE wicket_kind NOT IN ('NA', 'nan', 'retired', 'retired hurt', 'obstructing the field')
GROUP BY player_name
ORDER BY total_wickets DESC
LIMIT 1;


#8. Which bowlers have conceded the most runs across all formats?
SELECT player_name,
       SUM(runs_conceded) AS total_runs_conceded
FROM (
    SELECT bowler AS player_name, SUM(runs_total) AS runs_conceded
    FROM odi_ball_by_ball
    GROUP BY bowler

    UNION ALL

    SELECT bowler AS player_name, SUM(runs_total) AS runs_conceded
    FROM t20_ball_by_ball
    GROUP BY bowler

    UNION ALL

    SELECT bowler AS player_name, SUM(runs_total) AS runs_conceded
    FROM test_ball_by_ball
    GROUP BY bowler

    UNION ALL

    SELECT bowler AS player_name, SUM(runs_total) AS runs_conceded
    FROM ipl_ball_by_ball
    GROUP BY bowler
) AS all_formats
GROUP BY player_name
ORDER BY total_runs_conceded DESC
LIMIT 10;

#9. Who are the top 10 bowlers with the best economy rate in T20 and IPL matches?
SELECT 
    combined.bowler AS player_name,
    ROUND((SUM(CAST(runs_batter AS UNSIGNED)) + SUM(CAST(wides AS UNSIGNED)) + SUM(CAST(no_balls AS UNSIGNED))) / 
        (COUNT(*) - COUNT(CASE WHEN CAST(wides AS UNSIGNED) != 0 THEN 1 END) - COUNT(CASE WHEN CAST(no_balls AS UNSIGNED) != 0 THEN 1 END)) * 6, 2
    ) AS economy_rate
FROM (
    SELECT t20.* FROM t20_ball_by_ball t20
    JOIN t20_match_summary t20m ON t20.match_id = t20m.match_id
    WHERE t20m.gender = 'male'

    UNION ALL

    SELECT ipl.* FROM ipl_ball_by_ball ipl
    JOIN ipl_match_summary iplm ON ipl.match_id = iplm.match_id
    WHERE iplm.gender = 'male'
) AS combined
WHERE runs_batter != 'NA'
GROUP BY combined.bowler
HAVING (COUNT(*) - COUNT(CASE WHEN CAST(wides AS UNSIGNED) != 0 THEN 1 END) - COUNT(CASE WHEN CAST(no_balls AS UNSIGNED) != 0 THEN 1 END)) >= 60
ORDER BY economy_rate ASC
LIMIT 10;

#10. Which bowlers have bowled the most dot balls in IPL matches?
SELECT bowler AS player_name,
       COUNT(*) AS dot_balls
FROM ipl_ball_by_ball
WHERE runs_total = 0
GROUP BY player_name
ORDER BY dot_balls DESC
LIMIT 10;

#11. Who are the top 10 IPL bowlers with the best strike rate with a minimum of 10 wickets?
SELECT bowler AS player_name,
       COUNT(*) AS total_deliveries,
       COUNT(CASE WHEN wicket_kind NOT IN ('NA', 'nan', 'retired', 'retired hurt', 'obstructing the field') THEN 1 END) AS total_wickets,
       ROUND(
         COUNT(*) / 
         NULLIF(COUNT(CASE WHEN wicket_kind NOT IN ('NA', 'nan', 'retired', 'retired hurt', 'obstructing the field') THEN 1 END), 0), 2
       ) AS strike_rate
FROM ipl_ball_by_ball
GROUP BY player_name
HAVING total_wickets >= 10
ORDER BY strike_rate ASC
LIMIT 10;

# 12. Which 5 players have hit the most fours in IPL matches?
SELECT 
    batter AS player_name,
    COUNT(*) AS total_fours
FROM ipl_ball_by_ball
WHERE runs_batter = 4
GROUP BY batter
ORDER BY total_fours DESC
LIMIT 10;

# 13. Which 5 players have hit the most sixes in IPL matches?
SELECT 
    batter AS player_name,
    COUNT(*) AS total_fours
FROM ipl_ball_by_ball
WHERE runs_batter = 6
GROUP BY batter
ORDER BY total_fours DESC
LIMIT 10;

#14. Which international cricket team has the highest win percentage across Tests, ODIs, and T20s (minimum 100 matches played)?
SELECT team_name,
       COUNT(*) AS matches_played,
       SUM(CASE WHEN team_name = winner THEN 1 ELSE 0 END) AS matches_won,
       ROUND(SUM(CASE WHEN team_name = winner THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS win_percentage
FROM (
    SELECT team_1 AS team_name, winner FROM odi_match_summary
    UNION ALL
    SELECT team_2 AS team_name, winner FROM odi_match_summary

    UNION ALL
    SELECT team_1 AS team_name, winner FROM t20_match_summary
    UNION ALL
    SELECT team_2 AS team_name, winner FROM t20_match_summary

    UNION ALL
    SELECT team_1 AS team_name, winner FROM test_match_summary
    UNION ALL
    SELECT team_2 AS team_name, winner FROM test_match_summary
) AS all_matches
GROUP BY team_name
HAVING COUNT(*) > 100
ORDER BY win_percentage DESC;

#15.Which IPL team has the highest win percentage (minimum 20 matches played)?
SELECT team_name,
       COUNT(*) AS matches_played,
       SUM(CASE WHEN team_name = winner THEN 1 ELSE 0 END) AS matches_won,
       ROUND(SUM(CASE WHEN team_name = winner THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS win_percentage
FROM (
    SELECT team_1 AS team_name, winner FROM ipl_match_summary
    UNION ALL
    SELECT team_2 AS team_name, winner FROM ipl_match_summary
) AS all_matches
GROUP BY team_name
HAVING COUNT(*) > 20
ORDER BY win_percentage DESC;

#16. Which IPL teams have scored 200 or more runs the most times?
SELECT inning_team,
       COUNT(*) AS total_200_plus_scores
FROM (
    SELECT match_id, inning_team, SUM(runs_total) AS innings_total
    FROM ipl_ball_by_ball
    GROUP BY match_id, inning_team
) AS combined_innings
WHERE innings_total >= 200
GROUP BY inning_team
ORDER BY total_200_plus_scores DESC
LIMIT 10;

#17. Which international teams have taken the most wickets across ODIs, T20s, and Test matches?
SELECT inning_team AS team_name,
       COUNT(*) AS total_wickets_taken
FROM (
    SELECT inning_team, wicket_kind
    FROM odi_ball_by_ball
    WHERE wicket_kind NOT IN ('NA', 'nan', 'run out', 'retired', 'retired hurt', 'obstructing the field')

    UNION ALL

    SELECT inning_team, wicket_kind
    FROM t20_ball_by_ball
    WHERE wicket_kind NOT IN ('NA', 'nan', 'run out', 'retired', 'retired hurt', 'obstructing the field')

    UNION ALL

    SELECT inning_team, wicket_kind
    FROM test_ball_by_ball
    WHERE wicket_kind NOT IN ('NA', 'nan', 'run out', 'retired', 'retired hurt', 'obstructing the field')
) AS valid_wickets
GROUP BY team_name
ORDER BY total_wickets_taken DESC
LIMIT 10;

#18. Which 5 IPL teams have successfully chased the highest targets?

SELECT 
    ms.winner AS team_that_chased,
    ms.target_runs
FROM ipl_match_summary ms
WHERE ms.target_runs IS NOT NULL
  AND ms.winner = ms.team_2  -- team_2 batted second, and they won
ORDER BY ms.target_runs DESC
LIMIT 5;

#19. Which teams have scored the most runs in the powerplay (first 6 overs) in an IPL match?

SELECT 
    match_id,
    inning_team AS team,
    SUM(runs_total) AS powerplay_runs
FROM ipl_ball_by_ball
WHERE over_number < 6  -- First 6 overs (0 to 5.x)
GROUP BY match_id, inning_team
ORDER BY powerplay_runs DESC
LIMIT 5;

#20. What is the total number of runs scored in each IPL season?

SELECT 
    ims.season,
    SUM(ibb.runs_total) AS total_runs
FROM ipl_ball_by_ball ibb
JOIN ipl_match_summary ims ON ibb.match_id = ims.match_id
GROUP BY ims.season
ORDER BY ims.season;

#21. Which teams have won the toss the most times in IPL history?

SELECT toss_winner, COUNT(*) AS toss_wins
FROM ipl_match_summary
GROUP BY toss_winner
ORDER BY toss_wins DESC
LIMIT 10;

#22.What is the win percentage of IPL teams after winning the toss?

SELECT 
    toss_winner AS team,
    COUNT(*) AS toss_wins,
    SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) AS toss_and_match_wins,
    ROUND(SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS win_percentage_after_toss
FROM ipl_match_summary
GROUP BY toss_winner
ORDER BY win_percentage_after_toss DESC;


#23. How many matches have RCB and CSK each won against each other in IPL history?

SELECT 
    winner,
    COUNT(*) AS wins
FROM ipl_match_summary
WHERE 
    (team_1 IN ('Royal Challengers Bengaluru', 'Chennai Super Kings') AND 
     team_2 IN ('Royal Challengers Bengaluru', 'Chennai Super Kings'))
    AND winner IS NOT NULL
GROUP BY winner
ORDER BY wins DESC;

#24 What is the win record between Mumbai Indians and Chennai Super Kings in the IPL?

SELECT 
    winner,
    COUNT(*) AS wins
FROM ipl_match_summary
WHERE 
    (team_1 IN ('Mumbai Indians', 'Chennai Super Kings') AND 
     team_2 IN ('Mumbai Indians', 'Chennai Super Kings'))
    AND winner IS NOT NULL
GROUP BY winner
ORDER BY wins DESC;

#25 Who has won more Test matches between England and Australia?

SELECT 
    winner,
    COUNT(*) AS wins
FROM test_match_summary
WHERE 
    team_1 IN ('England', 'Australia') AND
    team_2 IN ('England', 'Australia') AND
    winner IN ('England', 'Australia') -- Exclude draws or no result
GROUP BY winner
ORDER BY wins DESC;

#26 How many ODIs have India and Pakistan each won against each other?
SELECT 
    winner,
    COUNT(*) AS wins
FROM odi_match_summary
WHERE 
    team_1 IN ('India', 'Pakistan') AND
    team_2 IN ('India', 'Pakistan') AND
    winner IN ('India', 'Pakistan')  -- Exclude no-result/draws
GROUP BY winner
ORDER BY wins DESC;

