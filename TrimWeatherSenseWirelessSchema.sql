-- the event scheduler is off by default, this setting works for a session but will be reset if the service restarts
-- be sure to run the enableMariaDbEventScheduler.sh script to enable the event scheduler across restarts
SET GLOBAL event_scheduler=ON;

USE WeatherSenseWireless;

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
    ('AQI433MHZ', 90),
    ('Generic', 90),
    ('IndoorTHSensors', 90),
    ('SolarMax433MHZ', 90),
    ('TB433MHZ', 90),
    ('WeatherData', 90)
ON DUPLICATE KEY UPDATE
    KeepInDays = VALUES(KeepInDays);

-- Create the trim events for the SkyWeather tables
-- the each event will run at 3am and repeat daily

DELIMITER |
CREATE OR REPLACE EVENT TrimAQI433MHZTable
    ON SCHEDULE EVERY 1 DAY
    STARTS (CURRENT_DATE() + INTERVAL 3 HOUR) + INTERVAL 1 DAY
    ENABLE
    COMMENT 'Trims the data in the AQI433MHZ table based on the TrimToInDays value in the TrimSpans table at 3am'
    DO
        BEGIN
            SELECT ADDDATE(current_timestamp(), -`KeepInDays`) INTO @trimToInDays
            FROM `TrimSpans` as ts
            WHERE ts.`TargetTable` = 'AQI433MHZ';
            DELETE FROM `AQI433MHZ`
            WHERE `timestamp` <= @trimToInDays;
        END |
DELIMITER ;

DELIMITER |
CREATE OR REPLACE EVENT TrimGenericTable
    ON SCHEDULE EVERY 1 DAY
    STARTS (CURRENT_DATE() + INTERVAL 3 HOUR) + INTERVAL 1 DAY
    ENABLE
    COMMENT 'Trims the data in the Generic table based on the TrimToInDays value in the TrimSpans table at 3am'
    DO
        BEGIN
            SELECT ADDDATE(current_timestamp(), -`KeepInDays`) INTO @trimToInDays
            FROM `TrimSpans` as ts
            WHERE ts.`TargetTable` = 'Generic';
            DELETE FROM `Generic`
            WHERE `TimeStamp` <= @trimToInDays;
        END |
DELIMITER ;

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
CREATE OR REPLACE EVENT TrimSolarMax433MHZTable
    ON SCHEDULE EVERY 1 DAY
    STARTS (CURRENT_DATE() + INTERVAL 3 HOUR) + INTERVAL 1 DAY
    ENABLE
    COMMENT 'Trims the data in the SolarMax433MHZ table based on the TrimToInDays value in the TrimSpans table at 3am'
    DO
        BEGIN
            SELECT ADDDATE(current_timestamp(), -`KeepInDays`) INTO @trimToInDays
            FROM `TrimSpans` as ts
            WHERE ts.`TargetTable` = 'SolarMax433MHZ';
            DELETE FROM `SolarMax433MHZ`
            WHERE `TimeStamp` <= @trimToInDays;
        END |
DELIMITER ;

DELIMITER |
CREATE OR REPLACE EVENT TrimTB433MHZTable
    ON SCHEDULE EVERY 1 DAY
    STARTS (CURRENT_DATE() + INTERVAL 3 HOUR) + INTERVAL 1 DAY
    ENABLE
    COMMENT 'Trims the data in the TB433MHZ table based on the TrimToInDays value in the TrimSpans table at 3am'
    DO
        BEGIN
            SELECT ADDDATE(current_timestamp(), -`KeepInDays`) INTO @trimToInDays
            FROM `TrimSpans` as ts
            WHERE ts.`TargetTable` = 'TB433MHZ';
            DELETE FROM `TB433MHZ`
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