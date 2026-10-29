/*

Cleaning Data in SQL Queries

*/

use nashville_housing_db;
-- 1.Standardize Date Format
SELECT 
    SaleDate,
    STR_TO_DATE(SaleDate, '%M %e, %Y') AS SaleDateConverted
FROM nashville_housing;
-- ALTER TABLE nashville_housing
-- Add SaleDateConverted Date;
Update nashville_housing
SET SaleDate = STR_TO_DATE(SaleDate, '%M %e, %Y');


-- Populate Property Address data
select * from nashville_housing
-- where PropertyAddress is null
order by ParcelID;-- Same parcelid is having same address

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from nashville_housing a
join nashville_housing b
on a.ParcelID=b.ParcelID
and a.UniqueId <> b.UniqueID
where a.PropertyAddress is null;

Update nashville_housing a
join nashville_housing b
on a.ParcelID=b.ParcelID
and a.UniqueId <> b.UniqueID
set a.PropertyAddress=coalesce(a.PropertyAddress,b.PropertyAddress)
where a.PropertyAddress is null;

-- Breaking out Address into Individual Columns (Address, City, State)
select PropertyAddress from nashville_housing;
SELECT
     PropertyAddress,
    -- Part 1: Everything before the first comma
    TRIM(SUBSTRING_INDEX(PropertyAddress, ',', 1)) AS Address,

    -- Part 2: Everything after the first comma
    TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
FROM nashville_housing;

Alter table nashville_housing
add PropertySplitAddress VARCHAR(255);

UPDATE nashville_housing
SET PropertySplitAddress=TRIM(SUBSTRING_INDEX(PropertyAddress, ',', 1));

Alter table nashville_housing
add PropertySplitCity VARCHAR(255);

UPDATE nashville_housing
SET PropertySplitCity=TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));

select * from nashville_housing;


Select OwnerAddress
From nashville_housing;

SELECT OwnerAddress,
    -- Part 3 (Address): 1st element from the left
    TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1)) AS OwnerSplitAddress,
    
    -- Part 2 (City): Take first 2 parts, then the last 1
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS OwnerSplitCity,
    
    -- Part 1 (State): 1st element from the right
    TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS OwnerSplitState
FROM nashville_housing;


Alter table nashville_housing
add OwnerSplitAddress VARCHAR(255);

UPDATE nashville_housing
SET OwnerSplitAddress=TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1));

Alter table nashville_housing
add OwnerSplitCity VARCHAR(255);

UPDATE nashville_housing
SET OwnerSplitCity=TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1));

Alter table nashville_housing
add OwnerSplitState VARCHAR(255);

UPDATE nashville_housing
SET OwnerSplitState=TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field
select distinct(SoldAsVacant),count(SoldAsVacant) 
from nashville_housing
Group by SoldAsVacant
order by 2;

select 
case 
when SoldAsVacant='N' then 'No'
when SoldAsVacant='Y' then 'Yes'
else SoldAsVacant
end as SoldAsVacant
from nashville_housing;

Update nashville_housing
set SoldAsVacant=case 
when SoldAsVacant='N' then 'No'
when SoldAsVacant='Y' then 'Yes'
else SoldAsVacant
end;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
from nashville_housing
-- order by ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns
Select *
From nashville_housing;


ALTER TABLE nashville_housing
DROP COLUMN TaxDistrict;
-- DROP COLUMN OwnerAddress,
-- DROP COLUMN PropertyAddress,
-- DROP COLUMN SaleDate;