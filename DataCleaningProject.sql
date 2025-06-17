/*
Cleaning Data in SQL Queries
*/



SELECT * FROM dbo.NashvilleHousing;

--Standardize Data Format
SELECT SaleDateConverted, CONVERT(Date,SaleDate) 
FROM dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing 
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--Populate Property Address data
SELECT *
FROM dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL;
order by ParcelID

SELECT a.parcelID, a.propertyAddress, b.parcelID, b.propertyAddress, ISNULL(a.propertyAddress,b.propertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
ON a.parcelID = b.parcelID
AND a. [uniqueID] <> b. [uniqueID]
WHERE a.propertyAddress IS NULL;


UPDATE a
SET propertyAddress = ISNULL(a.propertyAddress,b.propertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
ON a.parcelID = b.parcelID
AND a. [uniqueID] <> b. [uniqueID]
WHERE a.propertyAddress IS NULL;


--Breaking out Address into individual columns (Address,City,State)
SELECT propertyAddress
FROM dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL;
--order by ParcelID


SELECT 
  SUBSTRING(propertyAddress, 1, CHARINDEX(',', propertyAddress) - 1) AS StreetAddress,
  SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress) + 1, LEN(propertyAddress)) AS City
FROM dbo.NashvilleHousing;


ALTER TABLE NashvilleHousing 
ADD propertysplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET propertysplitAddress =  SUBSTRING(propertyAddress, 1, CHARINDEX(',', propertyAddress) - 1)

ALTER TABLE NashvilleHousing 
ADD  propertysplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET propertysplitCity =  SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress) + 1, LEN(propertyAddress))



SELECT*
FROM dbo.NashvilleHousing;






SELECT ownerAddress
FROM dbo.NashvilleHousing;


SELECT 
PARSENAME( REPLACE (ownerAddress,',', '.')  ,3)
,PARSENAME( REPLACE (ownerAddress,',', '.')  ,2)
,PARSENAME( REPLACE (ownerAddress,',', '.')  ,1)
FROM dbo.NashvilleHousing;



ALTER TABLE NashvilleHousing 
ADD ownersplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET ownerSplitAddress = PARSENAME(REPLACE(ownerAddress, ',', '.'), 3);


ALTER TABLE NashvilleHousing 
ADD  ownersplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET ownerSplitCity = PARSENAME(REPLACE(ownerAddress, ',', '.'), 2);


ALTER TABLE NashvilleHousing 
ADD  ownersplitState Nvarchar(255);

UPDATE NashvilleHousing
SET ownersplitState = PARSENAME( REPLACE (ownerAddress,',', '.')  ,1)


SELECT *
FROM dbo.NashvilleHousing;



--Change 1 and 0 to Yes and No in "sold as Vacant" field.
SELECT SoldAsVacant, COUNT(*) AS Count
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

ALTER TABLE NashvilleHousing
ALTER COLUMN SoldAsVacant VARCHAR(3);

UPDATE NashvilleHousing
SET SoldAsVacant = 'Yes'
WHERE SoldAsVacant = '1';

UPDATE NashvilleHousing
SET SoldAsVacant = 'No'
WHERE SoldAsVacant = '0';

SELECT *
FROM dbo.NashvilleHousing;





--Remove Duplicates

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY 
			parcelID, 
			propertyAddress, 
			SalePrice, 
			SaleDate, 
			LegalReference
            ORDER BY uniqueID
        ) AS row_num
    FROM dbo.NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1;

SELECT *
FROM dbo.NashvilleHousing;



--Delete Unused Columns

SELECT *
FROM dbo.NashvilleHousing;

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN ownerAddress, TaxDistrict, propertyAddress

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN SaleDate















