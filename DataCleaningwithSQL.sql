SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing

--Converting date format

SELECT SaleDate, CONVERT(date, SaleDate)
FROM PortfolioProject1.dbo.NashvilleHousing

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
ADD SaleDateConverted Date;

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populating Property Address data

--Checking for nulls in PropertyAddress column (29 detected)
SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL

--Looking at ParcelIDs to see if they could be used to populate null values in PropertyAddress
SELECT *
FROM PortfolioProject1.dbo.NashvilleHousing
ORDER BY ParcelID

--Self Join of table to allow matching of ParcelIDs with Property Addresses
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject1.dbo.NashvilleHousing a
JOIN PortfolioProject1.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Updating NashvilleHousing table using ISNULL statement to populate PropertyAddress when it is null using known addresses associated with PropertyIDs
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject1.dbo.NashvilleHousing a
JOIN PortfolioProject1.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--Breaking out PropertyAddress into individual columns (Address, City, State)
--Looking at PropertyAddress to see how to divide it
SELECT PropertyAddress
FROM PortfolioProject1.dbo.NashvilleHousing

--Using SUBSTRING
--First substring is starting at position 1 and returning through the first comma it encouters, using -1 so comma isn't returned in output
--Second substrig is using the CHARINDEX function for starting position (+1 so it starts after the comma) and LEN(PropertyAddress) to return everything after the comma
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM PortfolioProject1.dbo.NashvilleHousing

--Adding split address and city columns to the NashvilleHousing table

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

-- Checking that columns were added correctly
SELECT*
FROM PortfolioProject1.dbo.NashvilleHousing

--Using PARSENAME
--PARSENAME works with period delimiters so you need to replace the commas with periods
--PARSENAME works from right to left, so 1 gives you the information after the last delimiter, 2 gives you the information after the second to last delimiter, etc.
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
, PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
, PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM PortfolioProject1.dbo.NashvilleHousing

--Adding the Owner split address, city, and state columns to the NashvilleHousing table
ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

-- Checking that columns were added correctly
SELECT*
FROM PortfolioProject1.dbo.NashvilleHousing


--Change Y and N to Yes and No in SoldAsVacant field

--Checking the distinct values in the SoldAsVacant field (discovering inconsistency in entries with mostly Yes and No values but some Y and N)
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject1.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

--Using CASE statement to standardize the entries
SELECT SoldAsVacant
,	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM PortfolioProject1.dbo.NashvilleHousing

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END


--Remove duplicates

--Setting up CTE to look for duplicate entries that won't be useful for further analysis, row_number will be greater than 1 for entries with the same information in the listed fields as another row
WITH RowNumCTE AS(
SELECT *
	, ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProject1.dbo.NashvilleHousing
)
--using the CTE to select the duplicate rows to review output
SELECT*
FROM RowNumCTE
WHERE row_num >1
ORDER BY PropertyAddress

--using the CTE to delete the duplicate rows
WITH RowNumCTE AS(
SELECT *
	, ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProject1.dbo.NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num >1

--Delete unused columns (although would typically use view instead and consult team before deleting columns)

ALTER TABLE PortfolioProject1.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict

--Checking cleaned dataset
SELECT*
FROM PortfolioProject1.dbo.NashvilleHousing