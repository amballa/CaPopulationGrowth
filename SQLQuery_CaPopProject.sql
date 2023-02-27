-- Creating Table for Birth per County per Year

DROP TABLE IF EXISTS #BirthsFinal
CREATE TABLE #BirthsFinal (
	Year int,
	County varchar(50),
	Count int
)

INSERT INTO #BirthsFinal
SELECT Year, County, Count
FROM CaBirths
WHERE Strata = 'Total Population' 
	AND Geography_Type = 'Residence'
	AND Year >= 1970

-- Creating Table for Deaths per County per Year

DROP TABLE IF EXISTS #DeathsFinal
CREATE TABLE #DeathsFinal (
	Year int,
	County varchar(50),
	Count int
)

INSERT INTO #DeathsFinal
SELECT Year, County, Count
FROM CaDeaths7078
WHERE Strata = 'Total Population' 
	AND Geography_Type = 'Residence'
	AND Cause = 'ALL'
UNION
SELECT Year, County, Count
FROM CaDeaths7998
WHERE Strata = 'Total Population' 
	AND Geography_Type = 'Residence'
	AND Cause = 'ALL'
UNION
SELECT Year, County, Count
FROM CaDeaths9913
WHERE Strata = 'Total Population' 
	AND Geography_Type = 'Residence'
	AND Cause = 'ALL'
UNION
SELECT Year, County, Count
FROM CaDeaths1421
WHERE Strata = 'Total Population' 
	AND Geography_Type = 'Residence'
	AND Cause = 'ALL'

-- Creating Table for Net Gain per County per Year

DROP TABLE IF EXISTS CaNetGrowth
CREATE TABLE CaNetGrowth (
	Year int,
	County varchar(50),
	Births int,
	Deaths int,
	NetGrowth int
)

INSERT INTO CaNetGrowth
SELECT births.Year, births.County, 
	   births.Count as Births, deaths.Count as Deaths,
	   births.Count - deaths.Count as NetGrowth
FROM #BirthsFinal births
INNER JOIN #DeathsFinal deaths
	ON births.Year = deaths.Year
	AND births.County = deaths.County
ORDER BY 1, 2

--Ensuring No Missing Vaues

SELECT Count(*)
FROM CaNetGrowth
WHERE Year IS NULL OR
	  County IS NULL OR
	  Deaths iS NULL OR
	  NetGrowth IS NULL

-- Final Table for Visualization in Tableau

SELECT * FROM CaNetGrowth
