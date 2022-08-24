/*

Cleaning Data in SQL Queries 

*/

Select *
From PortfolioProject.dbo.NashvilleHousing




-------------------------------------------------------------------------------------------------------


--Standardize Date Format 

-- Standardize Date Format


Select Saledate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)
  
--------------------------------------------------------------------------------------------------------

--Populate Property Adress data 

Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null 
Order By ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns(Address, City, State) 

Select PropertyAddress 
FROM PortfolioProject.dbo.NashvilleHousing
order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select * 
From PortfolioProject.dbo.NashvilleHousing






Select OwnerAddress 
From PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.') , 3)
,PARSENAME(REPLACE(OwnerAddress,',','.') , 2)
,PARSENAME(REPLACE(OwnerAddress,',','.') , 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE Nashvillehousing 
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') , 2)


ALTER TABLE NashvilleHousing 
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing 
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') , 1)


Select * 
From PortfolioProject.dbo.NashvilleHousing
--------------------------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field 

Select Distinct(SoldasVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing 
SET SoldasVacant = CASE when SoldAsVacant = 'Y' THEN 'YES' 
		When SoldAsVacant = 'N' Then 'No'
		ELSE SoldAsVacant
		END

-------------------------------------------------------------------------------------------------------------------------------------

--Remove Unused Columns 


Select * 
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

Select * 
From PortfolioProject.dbo.NashvilleHousing
