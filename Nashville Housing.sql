Select *
From PORTFOLIO.dbo.nashville

Select SaleDate, CONVERT(Date,SaleDate) as SaleDateConverted
From PORTFOLIO.dbo.nashville

UPDATE PORTFOLIO.dbo.nashville
SET SaleDate = CONVERT(Date, SaleDate)



ALTER TABLE PORTFOLIO.dbo.nashville
ADD SaleDateConverted DATE;

UPDATE PORTFOLIO.dbo.nashville
SET SaleDateConverted = CONVERT(DATE, SaleDate)


Select *
From PORTFOLIO.dbo.nashville
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PORTFOLIO.dbo.nashville a
JOIN PORTFOLIO.dbo.nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PORTFOLIO.dbo.nashville a
JOIN  PORTFOLIO.dbo.nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



Select PropertyAddress
From PORTFOLIO.dbo.nashville
Where PropertyAddress is null
order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PORTFOLIO.dbo.nashville


ALTER TABLE PORTFOLIO.dbo.nashville
Add PropertySplitAddress Nvarchar(255);

Update PORTFOLIO.dbo.nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PORTFOLIO.dbo.nashville
Add PropertySplitCity Nvarchar(255);

Update PORTFOLIO.dbo.nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select OwnerAddress
From PORTFOLIO.dbo.nashville


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PORTFOLIO.dbo.nashville


ALTER TABLE PORTFOLIO.dbo.nashville
Add OwnerSplitAddress Nvarchar(255);

Update PORTFOLIO.dbo.nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PORTFOLIO.dbo.nashville
Add OwnerSplitCity Nvarchar(255);

Update PORTFOLIO.dbo.nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE PORTFOLIO.dbo.nashville
Add OwnerSplitState Nvarchar(255);

Update PORTFOLIO.dbo.nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From PORTFOLIO.dbo.nashville


---------------------------------------------------------------------------------------------


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PORTFOLIO.dbo.nashville
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PORTFOLIO.dbo.nashville


Update PORTFOLIO.dbo.nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




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

From PORTFOLIO.dbo.nashville
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From PORTFOLIO.dbo.nashville


ALTER TABLE PORTFOLIO.dbo.nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
