-- Theme 3: Property Characteristics & Asset Profiling
-- 3.1: Room Configurations & Marginal Value of Bathrooms
-- Bed & Bath Configuration Matrix
select Bedrooms, FullBath ,
COUNT(*) AS TotalTransactions,
ROUND(AVG(SalePrice), 2) AS AvgSalePrice,
-- Marginal comparison of median proxy
ROUND(AVG(BuildingValue), 2) AS AvgBuildingValue,
ROUND(AVG(SalePrice) / NULLIF(AVG(LandValue + BuildingValue), 0), 2) AS PriceToValueRatio
from nashville_housing
WHERE Bedrooms BETWEEN 2 AND 5
AND FullBath BETWEEN 1 AND 4
group by Bedrooms,FullBath
order by Bedrooms,FullBath;

-- 3.2: Price Premium of Construction Eras (Historic vs. New Builds)
WITH EraCTE AS (
    SELECT 
        CASE 
            WHEN YearBuilt < 1950 THEN '1. Pre-1950 (Historic)'
            WHEN YearBuilt BETWEEN 1950 AND 1970 THEN '2. 1950-1970 (Mid-Century)'
            WHEN YearBuilt BETWEEN 1971 AND 1990 THEN '3. 1971-1990 (Late Century)'
            WHEN YearBuilt BETWEEN 1991 AND 2000 THEN '4. 1991-2000 (Turn of Century)'
            WHEN YearBuilt BETWEEN 2001 AND 2010 THEN '5. 2001-2010 (Modern 2000s)'
            ELSE '6. 2011+ (New Construction)'
        END AS ConstructionEra,
        SalePrice,
        Acreage,
        LandValue,
        BuildingValue
    FROM nashville_housing
    WHERE YearBuilt IS NOT NULL 
      AND YearBuilt > 1800
      AND SalePrice > 10000
)
SELECT 
    ConstructionEra,
    COUNT(*) AS TotalHomesSold,
    ROUND(AVG(SalePrice), 2) AS AvgSalePrice,
    ROUND(AVG(BuildingValue), 2) AS AvgBuildingValue,
    ROUND(AVG(LandValue), 2) AS AvgLandValue,
    ROUND(AVG(Acreage), 2) AS AvgLotSizeAcreage,
    ROUND(AVG(LandValue) * 100.0 / NULLIF(AVG(LandValue + BuildingValue), 0), 2) AS LandSharePct
FROM EraCTE
GROUP BY ConstructionEra
ORDER BY ConstructionEra;

-- Theme 4
-- Vacant vs. Occupied Valuation Analysis

-- 4.1: Do Vacant Properties Trade at a Steep Discount?
SELECT 
    SoldAsVacant,
    COUNT(*) AS TotalTransactions,
    ROUND(AVG(SalePrice), 2) AS AvgSalePrice,
    -- Valuation metrics
    ROUND(AVG(TotalValue), 2) AS AvgAssessedValue,
    ROUND(AVG(Acreage), 2) AS AvgAcreage,
    ROUND(AVG(SalePrice) / NULLIF(AVG(TotalValue), 0), 2) AS PriceToValueRatio
FROM nashville_housing
GROUP BY SoldAsVacant;

-- 4.2 Single Family Specific Comparison Query
SELECT 
    SoldAsVacant,
    COUNT(*) AS TotalTransactions,
    ROUND(AVG(SalePrice), 2) AS AvgSalePrice,
    -- Valuation metrics
    ROUND(AVG(TotalValue), 2) AS AvgAssessedValue,
    ROUND(AVG(Acreage), 2) AS AvgAcreage,
    ROUND(AVG(SalePrice) / NULLIF(AVG(TotalValue), 0), 2) AS PriceToValueRatio
FROM nashville_housing
where LandUse='SINGLE FAMILY'
GROUP BY SoldAsVacant;

-- Theme 5: Institutional vs. Individual Ownership & Absentee Investors
-- Identifying Corporate Entities & Portfolio Concentration
WITH EntityClassification AS (
    SELECT 
        UniqueID,
        ParcelID,
        OwnerName,
        SalePrice,
        TotalValue,
        LandValue,
        BuildingValue,
        -- Detect business entity keywords
        CASE 
            WHEN OwnerName REGEXP '\\b(LLC|INC|CORP|LP|L\\.P\\.|TRUST|PROPERTIES|INVESTMENT|INVESTMENTS|HOLDINGS|HOMES|DEVELOPMENT|REALTY|VENTURES|EQUITY|BANK|PARTNERS|GROUP)\\b' 
            THEN 'Institutional / Corporate'
            ELSE 'Individual / Private'
        END AS OwnerEntityType
    FROM nashville_housing
    WHERE OwnerName IS NOT NULL
)
SELECT 
    OwnerEntityType,
    COUNT(*) AS TotalPropertiesHeld,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM EntityClassification), 2) AS PctShare,
    ROUND(AVG(SalePrice), 2) AS AvgSalePrice,
    ROUND(SUM(SalePrice) / 1000000, 2) AS TotalCapitalVolume_M,
    ROUND(AVG(LandValue), 2) AS AvgLandValue,
    ROUND(AVG(BuildingValue), 2) AS AvgBuildingValue
FROM EntityClassification
GROUP BY OwnerEntityType;
-- Top Landlords & Developer Portfolio Leaderboard
SELECT 
    OwnerName,
    COUNT(DISTINCT ParcelID) AS PropertiesOwned,
    ROUND(SUM(SalePrice), 2) AS TotalPortfolioCost,
    ROUND(AVG(SalePrice), 2) AS AvgAcquisitionPrice,
    ROUND(SUM(TotalValue), 2) AS TotalAssessedValue
FROM nashville_housing
WHERE OwnerName IS NOT NULL
GROUP BY OwnerName
ORDER BY PropertiesOwned DESC
LIMIT 10;
-- Owner-Occupied vs. Absentee Investor Analysis
WITH AbsenteeAnalysis AS (
    SELECT 
        UniqueID,
        ParcelID,
        PropertySplitAddress,
        OwnerSplitAddress,
        SalePrice,
        TotalValue,
        -- If physical property address does NOT match owner's tax mailing address
        CASE 
            WHEN UPPER(TRIM(PropertySplitAddress)) <> UPPER(TRIM(OwnerSplitAddress)) 
            THEN 'Absentee Owner (Rental / Investment)'
            ELSE 'Owner-Occupied (Primary Residence)'
        END AS OccupancyStatus
    FROM nashville_housing
    WHERE PropertySplitAddress IS NOT NULL 
      AND OwnerSplitAddress IS NOT NULL
)
SELECT 
    OccupancyStatus,
    COUNT(*) AS PropertyCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AbsenteeAnalysis), 2) AS PctShare,
    ROUND(AVG(SalePrice), 2) AS AvgSalePrice,
    ROUND(AVG(TotalValue), 2) AS AvgAssessedValue
FROM AbsenteeAnalysis
GROUP BY OccupancyStatus;
