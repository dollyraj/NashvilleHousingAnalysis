-- Theme 1:Market Trends & Macro Valuation
-- We will need sale year to aggregate
ALTER TABLE nashville_housing
ADD COLUMN SaleYear INT,
ADD COLUMN SaleMonth INT,
ADD COLUMN SaleYearMonth VARCHAR(255);

UPDATE nashville_housing
SET SaleYear=Year(SaleDate);

UPDATE nashville_housing
SET SaleMonth=Month(SaleDate);

UPDATE nashville_housing
SET SaleYearMonth=date_format(SaleDate,'%Y-%m');
-- Annual Transaction Volume & Price Growth
-- 1.1 Market Trends & Macro Valuation
SELECT 
    SaleYear,
    count(*) as TotalTransactions,
    Round(Avg(SalePrice),2) as AvgSalePrice,
    Round(LAG(Avg(SalePrice)) OVER (ORDER BY SaleYear),2) AS PreviousYearAvgSalePrice,
    -- Correct formula: (Current - Previous) / Previous * 100
    ROUND(
        (Avg(SalePrice) - LAG(Avg(SalePrice)) OVER (ORDER BY SaleYear)) 
        / LAG(Avg(SalePrice)) OVER (ORDER BY SaleYear) * 100, 
        2
    ) AS YoY_AvgPrice_Growth_Pct
FROM nashville_housing
Group BY SaleYear
ORDER BY SaleYear;


SELECT 
    SaleMonth,
    MONTHNAME(STR_TO_DATE(SaleMonth, '%m')) AS MonthName,
    COUNT(*) AS TotalTransactions,
    ROUND(AVG(SalePrice), 2) AS AvgPrice
    -- ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM nashville_housing WHERE SaleYear BETWEEN 2013 AND 2016), 2) AS PctOfTotalSales
FROM nashville_housing
WHERE SaleYear BETWEEN 2013 AND 2016
GROUP BY SaleMonth
ORDER BY SaleMonth;


-- 1.2 Seasonal Comparison Query
SELECT 
    CASE 
        WHEN SaleMonth IN (3, 4, 5) THEN 'Spring'
        WHEN SaleMonth IN (6, 7, 8) THEN 'Summer'
        WHEN SaleMonth IN (9, 10, 11) THEN 'Fall'
        ELSE 'Winter'
    END AS Season,
    COUNT(*) AS TotalTransactions,
    ROUND(COUNT(*) / 4.0, 0) AS AvgAnnualTransactions, -- 4 complete years (2013-2016)
    ROUND(AVG(SalePrice), 2) AS AvgSalePrice
FROM nashville_housing
WHERE SaleYear BETWEEN 2013 AND 2016
GROUP BY Season
ORDER BY TotalTransactions DESC;

select * from nashville_housing;

-- Theme2: Geographic 
-- This module segments market liquidity, property values, and land utilization across municipal tax districts and individual cities.
select * from nashville_housing ;
-- where OwnerSplitCity is null;
-- Price & Liquidity Breakdown by City
Select PropertySplitCity,
Count(*) as TotalTransaction,
ROUND(AVG(Acreage), 2) AS AvgAcreage,
Round(Avg(SalePrice),2) as AvgSalePrice,
ROUND(AVG(LandValue), 2) AS AvgLandValue,
ROUND(AVG(BuildingValue), 2) AS AvgBuildingValue,
ROUND(AVG(LandValue) * 100.0 / NULLIF(AVG(TotalValue), 0), 2) AS LandValueSharePct
from nashville_housing
where PropertyAddress is not null
group by PropertySplitCity;

