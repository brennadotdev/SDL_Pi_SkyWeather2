-- the event scheduler is off by default, this setting works for a session but will be reset if the service restarts
-- be sure to run the enableMariaDbEventScheduler.sh script to enable the event scheduler across restarts
SET GLOBAL event_scheduler=ON;

USE SkyWeather2;

-- This script is safe to run multiple times if you want to change the settings.
-- You can edit the values inserted into the TrimSpans table to control how much data is kept.

-- Create or replace the TrimSpans table
CREATE OR REPLACE TABLE `TrimSpans` (
    `TargetTable` VARCHAR(128) PRIMARY KEY COMMENT 'The table being trimmed',
    `KeepInDays` INT NOT NULL COMMENT 'The number of days worth of data to keep'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Default values for the TrimSpans table
-- Change these values and re-run this script to update the amount of data to be trimmed
INSERT INTO TrimSpans (TargetTable, KeepInDays)
VALUES
    ('IndoorTHSensors', 90),
    ('PowerSystem', 90),
    ('SystemLog', 7),
    ('WeatherData', 90)
ON DUPLICATE KEY UPDATE
    KeepInDays = VALUES(KeepInDays);

-- Create the trim events for the SkyWeather tables
-- the each event will run at 3am and repeat daily

DELIMITER |
CREATE OR REPLACE EVENT TrimIndoorTHSensorsTable
    ON SCHEDULE EVERY 1 DAY
    STARTS (CURRENT_DATE() + INTERVAL 3 HOUR) + INTERVAL 1 DAY
    ENABLE
    COMMENT 'Trims the data in the IndoorTHSensors table based on the TrimToInDays value in the TrimSpans table at 3am'
    DO
        BEGIN
            SELECT ADDDATE(current_timestamp(), -`KeepInDays`) INTO @trimToInDays
            FROM `TrimSpans` as ts
            WHERE ts.`TargetTable` = 'IndoorTHSensors';
            DELETE FROM `IndoorTHSensors`
            WHERE `TimeStamp` <= @trimToInDays;
        END |
DELIMITER ;

DELIMITER |
CREATE OR REPLACE EVENT TrimPowerSystemTable
    ON SCHEDULE EVERY 1 DAY
    STARTS (CURRENT_DATE() + INTERVAL 3 HOUR) + INTERVAL 1 DAY
    ENABLE
    COMMENT 'Trims the data in the PowerSystem table based on the TrimToInDays value in the TrimSpans table at 3am'
    DO
        BEGIN
            SELECT ADDDATE(current_timestamp(), -`KeepInDays`) INTO @trimToInDays
            FROM `TrimSpans` as ts
            WHERE ts.`TargetTable` = 'PowerSystem';
            DELETE FROM `PowerSystem`
            WHERE `TimeStamp` <= @trimToInDays;
        END |
DELIMITER ;

DELIMITER |
CREATE OR REPLACE EVENT TrimSystemLogTable
    ON SCHEDULE EVERY 1 DAY
    STARTS (CURRENT_DATE() + INTERVAL 3 HOUR) + INTERVAL 1 DAY
    ENABLE
    COMMENT 'Trims the data in the SystemLog table based on the TrimToInDays value in the TrimSpans table at 3am'
    DO
        BEGIN
            SELECT ADDDATE(current_timestamp(), -`KeepInDays`) INTO @trimToInDays
            FROM `TrimSpans` as ts
            WHERE ts.`TargetTable` = 'SystemLog';
            DELETE FROM `SystemLog`
            WHERE `TimeStamp` <= @trimToInDays;
        END |
DELIMITER ;

DELIMITER |
CREATE OR REPLACE EVENT TrimWeatherDataTable
    ON SCHEDULE EVERY 1 DAY
    STARTS (CURRENT_DATE() + INTERVAL 3 HOUR) + INTERVAL 1 DAY
    ENABLE
    COMMENT 'Trims the data in the WeatherData table based on the TrimToInDays value in the TrimSpans table at 3am'
    DO
        BEGIN
            SELECT ADDDATE(current_timestamp(), -`KeepInDays`) INTO @trimToInDays
            FROM `TrimSpans` as ts
            WHERE ts.`TargetTable` = 'WeatherData';
            DELETE FROM `WeatherData`
            WHERE `TimeStamp` <= @trimToInDays;
        END |
DELIMITER ;
