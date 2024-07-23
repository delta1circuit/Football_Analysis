CREATE TABLE players (
    player_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    name VARCHAR(255),
    last_season INT,
    current_club_id INT,
    player_code VARCHAR(255),
    country_of_birth VARCHAR(255),
    city_of_birth VARCHAR(255),
    country_of_citizenship VARCHAR(255),
    date_of_birth DATE,
    sub_position VARCHAR(255),
    position VARCHAR(255),
    foot VARCHAR(255),
    height_in_cm INT,
    contract_expiration_date DATE,
    agent_name VARCHAR(255),
    image_url VARCHAR(255),
    url VARCHAR(255),
    current_club_domestic_competition_id VARCHAR(255),
    current_club_name VARCHAR(255),
    market_value_in_eur NUMERIC,
    highest_market_value_in_eur NUMERIC
);

CREATE TABLE player_valuations (
    player_id INT,
    date DATE,
    market_value_in_eur INT,
    current_club_id INT,
    player_club_domestic_competition_id VARCHAR(255)
);

CREATE TABLE games (
    game_id INT PRIMARY KEY,
    competition_id VARCHAR(255),
    season INT,
    round VARCHAR(255),
    date DATE,
    home_club_id INT,
    away_club_id INT,
    home_club_goals INT,
    away_club_goals INT,
    home_club_position INT,
    away_club_position INT,
    home_club_manager_name VARCHAR(255),
    away_club_manager_name VARCHAR(255),
    stadium VARCHAR(255),
    attendance INT,
    referee VARCHAR(255),
    url VARCHAR(255),
    home_club_formation VARCHAR(255),
    away_club_formation VARCHAR(255),
    home_club_name VARCHAR(255),
    away_club_name VARCHAR(255),
    aggregate VARCHAR(255),
    competition_type VARCHAR(255)
);

CREATE TABLE game_lineups (
    game_lineups_id VARCHAR(255) PRIMARY KEY,
    date DATE,
    game_id INT,
    player_id INT,
    club_id INT,
    player_name VARCHAR(255),
    player_type VARCHAR(255),
    player_position VARCHAR(255),
    player_number INT,
    team_captain BOOLEAN
);

CREATE TABLE game_events (
    game_event_id VARCHAR(255) PRIMARY KEY,
    date DATE,
    game_id INT,
    minute INT,
    type VARCHAR(255),
    club_id INT,
    player_id INT,
    description TEXT,
    player_in_id INT,
    player_assist_id INT
);

CREATE TABLE competitions (
    competition_id VARCHAR(255) PRIMARY KEY,
    competition_code VARCHAR(255),
    name VARCHAR(255),
    sub_type VARCHAR(255),
    type VARCHAR(255),
    country_id INT,
    country_name VARCHAR(255),
    domestic_league_code VARCHAR(255),
    confederation VARCHAR(255),
    url VARCHAR(255),
    is_major_national_league BOOLEAN
);

CREATE TABLE clubs (
    club_id INT,
    club_code VARCHAR(255),
    name VARCHAR(255),
    domestic_competition_id VARCHAR(255),
    total_market_value NUMERIC,
    squad_size INT,
    average_age NUMERIC,
    foreigners_number INT,
    foreigners_percentage NUMERIC,
    national_team_players INT,
    stadium_name VARCHAR(255),
    stadium_seats INT,
    net_transfer_record NUMERIC,
    coach_name VARCHAR(255),
    last_season INT,
    filename VARCHAR(255),
    url VARCHAR(255)
);

CREATE TABLE clubs_staging (
    club_id INT,
    club_code VARCHAR(255),
    name VARCHAR(255),
    domestic_competition_id VARCHAR(255),
    total_market_value VARCHAR(255),
    squad_size INT,
    average_age NUMERIC,
    foreigners_number INT,
    foreigners_percentage NUMERIC,
    national_team_players INT,
    stadium_name VARCHAR(255),
    stadium_seats INT,
    net_transfer_record VARCHAR(255),
    coach_name VARCHAR(255),
    last_season INT,
    filename VARCHAR(255),
    url VARCHAR(255)
);

INSERT INTO clubs (club_id, club_code, name, domestic_competition_id, total_market_value, squad_size, average_age, foreigners_number, foreigners_percentage, national_team_players, stadium_name, stadium_seats, net_transfer_record, coach_name, last_season, filename, url)
SELECT
    club_id,
    club_code,
    name,
    domestic_competition_id,
    CASE
        WHEN total_market_value = '+-0' THEN 0
        WHEN total_market_value ~ '^\+?\€?\-?\d+(\.\d+)?[kKmMbB]?$' THEN
            CASE
                WHEN total_market_value ~ '[kK]$' THEN (regexp_replace(total_market_value, '[^\d\.\+\-]', '', 'g')::NUMERIC * 1000)
                WHEN total_market_value ~ '[mM]$' THEN (regexp_replace(total_market_value, '[^\d\.\+\-]', '', 'g')::NUMERIC * 1000000)
                WHEN total_market_value ~ '[bB]$' THEN (regexp_replace(total_market_value, '[^\d\.\+\-]', '', 'g')::NUMERIC * 1000000000)
                ELSE regexp_replace(total_market_value, '[^\d\.\+\-]', '', 'g')::NUMERIC
            END
        ELSE NULL
    END,
    squad_size,
    average_age,
    foreigners_number,
    foreigners_percentage,
    national_team_players,
    stadium_name,
    stadium_seats,
    CASE
        WHEN net_transfer_record = '+-0' THEN 0
        WHEN net_transfer_record ~ '^\+?\€?\-?\d+(\.\d+)?[kKmM]?$' THEN
            CASE
                WHEN net_transfer_record ~ '[kK]$' THEN ROUND((regexp_replace(net_transfer_record, '[^\d\.\+\-]', '', 'g')::NUMERIC * 1000))
                WHEN net_transfer_record ~ '[mM]$' THEN ROUND((regexp_replace(net_transfer_record, '[^\d\.\+\-]', '', 'g')::NUMERIC * 1000000))
                ELSE ROUND(regexp_replace(net_transfer_record, '[^\d\.\+\-]', '', 'g')::NUMERIC)
            END
        ELSE NULL
    END,
    coach_name,
    last_season,
    filename,
    url
FROM clubs_staging;

CREATE TABLE club_games (
    game_id INT,
    club_id INT,
    own_goals INT,
    own_position INT,
    own_manager_name VARCHAR(255),
    opponent_id INT,
    opponent_goals INT,
    opponent_position INT,
    opponent_manager_name VARCHAR(255),
    hosting VARCHAR(10),
    is_win BOOLEAN
);

CREATE TABLE appearances (
    appearance_id VARCHAR(255),
    game_id INT,
    player_id INT,
    player_club_id INT,
    player_current_club_id INT,
    date DATE,
    player_name VARCHAR(255),
    competition_id VARCHAR(255),
    yellow_cards INT,
    red_cards INT,
    goals INT,
    assists INT,
    minutes_played INT
);







