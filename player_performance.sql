-- Player performance analysis

-- Annual averages
SELECT
    p.player_id,
    p.first_name,
    p.last_name,
    p.current_club_name,
    p.position,
    EXTRACT(YEAR FROM pv.date) AS year,
    ROUND(AVG(pv.market_value_in_eur)) AS avg_market_value,
    COUNT(a.game_id) AS games_played,
    SUM(COALESCE(a.goals,0)) AS total_goals,
    SUM(COALESCE(a.assists,0)) AS total_assists,
    SUM(COALESCE(a.yellow_cards,0)) AS total_yellow_cards,
    SUM(COALESCE(a.red_cards,0)) AS total_red_cards,
    SUM(COALESCE(a.minutes_played,0)) AS total_minutes_played,
    COALESCE(ROUND(SUM(a.minutes_played) / COUNT(a.game_id)),0) AS avg_minutes_per_game
FROM
    players p
JOIN
    player_valuations pv ON p.player_id = pv.player_id
LEFT JOIN
    appearances a ON p.player_id = a.player_id AND EXTRACT(YEAR FROM pv.date) = EXTRACT(YEAR FROM a.date)
GROUP BY
    p.player_id, p.first_name, p.last_name, p.current_club_name, p.position, EXTRACT(YEAR FROM pv.date)
ORDER BY
    p.player_id, year;