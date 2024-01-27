
  --Cleaning Data in SQL
  select *
  from [portfolio project ].dbo.Naschvillhousing
  
  --Standardize Data Format
  select SaleDateFixed,convert(date,SaleDate)
  from [portfolio project ].dbo.Naschvillhousing
  
  
  update  Naschvillhousing
  set SaleDate=convert(date,SaleDate)


  ALTER TABLE Naschvillhousing
  ADD SaleDateFixed DATE;

   update  Naschvillhousing
  set SaleDateFixed=convert(date,SaleDate)

  --Populate property Address Data
   select a.ParcelID,a.propertyAddress,b.ParcelID,b.PropertyAddress,isnull( a.propertyAddress,b.PropertyAddress)
  from [portfolio project ].dbo.Naschvillhousing a
  JOIN [portfolio project ].dbo.Naschvillhousing b
  on a.ParcelID=b.ParcelID
  and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 update a
 set propertyAddress=isnull( a.propertyAddress,b.PropertyAddress)
 from [portfolio project ].dbo.Naschvillhousing a
  JOIN [portfolio project ].dbo.Naschvillhousing b
  on a.ParcelID=b.ParcelID
  and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null
  
  select *
  from [portfolio project ].dbo.Naschvillhousing

  --3 Breaking out Address Into Indevidual Columns 
    select PropertyAddress,SUBSTRING( PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
	SUBSTRING( PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as City
  from [portfolio project ].dbo.Naschvillhousing

   ALTER TABLE Naschvillhousing
  ADD PropertysplitAddress nvarchar(255);

   update  Naschvillhousing
  set PropertysplitAddress=SUBSTRING( PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

    ALTER TABLE Naschvillhousing
  ADD Propertysplitcity nvarchar(255);

   update  Naschvillhousing
  set Propertysplitcity=SUBSTRING( PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))
   
   select *
  from [portfolio project ].dbo.Naschvillhousing
  --4 Breaking out OwnerAddress Into Indevidual Columns
  select OwnerAddress ,parsename( replace(OwnerAddress,',','.'),3)
  ,parsename( replace(OwnerAddress,',','.'),2),
  parsename( replace(OwnerAddress,',','.'),1)
  from [portfolio project ].dbo.Naschvillhousing

  Alter Table Naschvillhousing
  add OwnersplitAddress nvarchar (255);
  update  Naschvillhousing
  set OwnersplitAddress=parsename( replace(OwnerAddress,',','.'),3)


   Alter Table Naschvillhousing
  add OwnersplitCity nvarchar (255);
  update  Naschvillhousing
  set OwnersplitCity=parsename( replace(OwnerAddress,',','.'),2)

   Alter Table Naschvillhousing
 add OwnersplitState nvarchar (255);
 update  Naschvillhousing
  set OwnersplitState= parsename( replace(OwnerAddress,',','.'),1)
    
	select OwnerAddress,OwnersplitAddress
  from [portfolio project ].dbo.Naschvillhousing
  
  --5 Change y and n into yes and no "soldasvacant" field
  select distinct(SoldAsVacant),count(SoldAsVacant)
  from [portfolio project ].dbo.Naschvillhousing
  group by SoldAsVacant
  order by 2
  select SoldAsVacant,case when SoldAsVacant='y' then 'yes'
  when SoldAsVacant='n' then 'no'
  else SoldAsVacant
  end
   from [portfolio project ].dbo.Naschvillhousing

   update Naschvillhousing
   set SoldAsVacant=case when SoldAsVacant='y' then 'yes'
  when SoldAsVacant='n' then 'no'
  else SoldAsVacant
  end
  --6 Removing Duplicates
  with row_numCTE as(
  select *,ROW_NUMBER()over(
                     partition by parcelID,
					              LandUse,
								  PropertyAddress,
								  SalePrice,
								  SaleDate,
								  LegalReference
								  order by UniqueID) row_num
  from [portfolio project ].dbo.Naschvillhousing
  )
  select *
  from row_numCTE
  where row_num > 1


  --Delete Unused Columns
  select *
  from [portfolio project ]..Naschvillhousing

  ALTER TABLE [portfolio project ]..Naschvillhousing
  DROP COLUMN SaleDate,PropertyAddress,OwnerAddress,TaxDistrict

