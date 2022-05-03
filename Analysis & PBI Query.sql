-- Investigate difference between 'Reported_by' and 'Falls_within' columns. No difference between the two columns so 'Reported_by' column dropped from both tables
SELECT Reported_by, count(Reported_by)
FROM [dbo].[PoliceOutcomes]
GROUP BY Reported_by

SELECT Falls_within, count(Falls_within)
FROM [dbo].[PoliceOutcomes]
GROUP BY Falls_within


SELECT Reported_by, count(Reported_by)
FROM [dbo].[PoliceStreet]
GROUP BY Reported_by

SELECT Falls_within, count(Falls_within)
FROM [dbo].[PoliceStreet]
GROUP BY Falls_within

ALTER TABLE [dbo].[PoliceOutcomes]
DROP COLUMN Reported_by

ALTER TABLE [dbo].[PoliceStreet]
DROP COLUMN Reported_by

-- Change 'Location' column to be lower case in both tables to enable a more accurate JOIN later on
UPDATE [dbo].[PoliceOutcomes] 
SET Location = LOWER(Location)

UPDATE [dbo].[PoliceStreet]
SET Location = LOWER(Location)


-- Explore how many 'Outcome_types' there are and how many times each appears in the dataset
SELECT Outcome_type, count(Outcome_type) as Appearance_Count
FROM PoliceOutcomes
GROUP BY Outcome_type
ORDER BY Appearance_Count DESC

-- Explore how many Boroughs there are and how many times each appears in the dataset 
SELECT SUBSTRING(LSOA_name,1,len(LSOA_name)-4) LSOA_Area, count(SUBSTRING(LSOA_name,1,len(LSOA_name)-4)) as Appearance_Count
FROM PoliceOutcomes
GROUP BY SUBSTRING(LSOA_name,1,len(LSOA_name)-4)
ORDER BY Appearance_Count DESC

-- Investigate what year had the most crime 
SELECT YEAR(Month) as Year, count(YEAR(Month)) as Crime_count
FROM PoliceOutcomes
GROUP BY YEAR(Month)
ORDER BY Crime_count DESC

-- The year view doesn't look accurate so investigate if we have full 12 months for each year
SELECT YEAR(Month) as Year, MONTH(Month) as Month, count(YEAR(Month)) as Crime_count
FROM PoliceOutcomes
GROUP BY YEAR(Month), MONTH(Month)
ORDER BY Year, Month ASC

-- Remove last 4 characters from LSOA_name so that the column has only the relevant Borough name
UPDATE PoliceOutcomes
SET LSOA_name=LEFT(LSOA_name, len(LSOA_name)-4)

UPDATE PoliceStreet
SET LSOA_name=LEFT(LSOA_name, len(LSOA_name)-4)


-- Query data into Power BI
SELECT PoliceOutcomes.Crime_ID, PoliceOutcomes.Month, PoliceOutcomes.Falls_within, PoliceOutcomes.Longitude, PoliceOutcomes.Latitude, PoliceOutcomes.Location, PoliceOutcomes.LSOA_code, PoliceOutcomes.LSOA_name, PoliceOutcomes.Outcome_type, PoliceStreet.Crime_type
FROM PoliceOutcomes
INNER JOIN PoliceStreet
ON PoliceOutcomes.Crime_ID = PoliceStreet.Crime_ID
AND PoliceOutcomes.Month = PoliceStreet.Month
AND PoliceOutcomes.Falls_within = PoliceStreet.Falls_within
AND PoliceOutcomes.Longitude = PoliceStreet.Longitude
AND PoliceOutcomes.Latitude = PoliceStreet.Latitude
AND PoliceOutcomes.Location = PoliceStreet.Location
AND PoliceOutcomes.LSOA_code = PoliceStreet.LSOA_code
AND PoliceOutcomes.LSOA_name = PoliceStreet.LSOA_name
ORDER BY PoliceOutcomes.Month
