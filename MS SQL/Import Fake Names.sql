USE [FakeNames]
GO

--  Step 1 - Temporary tables
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Person_Raw](
	[Id] [nvarchar](50) NULL,
	[Gender] [nvarchar](10) NULL,
	[GivenName] [nvarchar](50) NULL,
	[MiddleInitial] [nvarchar](10) NULL,
	[Surname] [nvarchar](50) NULL,
	[StreetAddress] [nvarchar](100) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](2) NULL,
	[ZipCode] [nvarchar](10) NULL,
	[Country] [nvarchar](2) NULL,
	[EmailAddress] [nvarchar](100) NULL,
	[Password] [nvarchar](50) NULL,
	[TelephoneNumber] [nvarchar](50) NULL,
	[MothersMaiden] [nvarchar](50) NULL,
	[Birthday] [nvarchar](50) NULL,
	[CCType] [nvarchar](50) NULL,
	[CCNumber] [nvarchar](50) NULL,
	[CVV2] [nvarchar](10) NULL,
	[CCExpires] [nvarchar](50) NULL,
	[NationalID] [nvarchar](50) NULL,
	[UPS] [nvarchar](50) NULL,
	[Occupation] [nvarchar](100) NULL,
	[Company] [nvarchar](100) NULL,
	[Domain] [nvarchar](200) NULL,
	[BloodType] [nvarchar](10) NULL,
	[Pounds] [nvarchar](50) NULL,
	[Kilograms] [nvarchar](50) NULL,
	[FeetInches] [nvarchar](10) NULL,
	[Centimeters] [nvarchar](50) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Person_Parsed](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Gender] [tinyint] NOT NULL,
	[GivenName] [nvarchar](50) NOT NULL,
	[MiddleInitial] [nvarchar](10) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[StreetAddress] [nvarchar](100) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[State] [nvarchar](2) NOT NULL,
	[ZipCode] [nvarchar](10) NOT NULL,
	[Country] [nvarchar](2) NOT NULL,
	[EmailAddress] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[TelephoneNumber] [nvarchar](50) NOT NULL,
	[MothersMaiden] [nvarchar](50) NOT NULL,
	[Birthday] [date] NOT NULL,
	[CCType] [nvarchar](50) NOT NULL,
	[CCNumber] [nvarchar](50) NOT NULL,
	[CVV2] [nvarchar](10) NOT NULL,
	[CCExpires] [date] NOT NULL,
	[NationalID] [nvarchar](50) NOT NULL,
	[UPS] [nvarchar](50) NOT NULL,
	[Occupation] [nvarchar](100) NOT NULL,
	[Company] [nvarchar](100) NOT NULL,
	[Domain] [nvarchar](200) NOT NULL,
	[BloodType] [nvarchar](10) NOT NULL,
	[Pounds] [real] NOT NULL,
	[Kilograms] [real] NOT NULL,
	[FeetInches] [nvarchar](10) NOT NULL,
	[Centimeters] [smallint] NOT NULL
) ON [PRIMARY]
GO


--  Step 2 - Import data - repeat for all CSVs
--  Remember to remove BOM and header row from CSV first!
BULK INSERT
	[FakeNames].[dbo].[Person_Raw]
FROM
	's:\backup\FakeNames\xxxxxx.csv'
WITH
	(FIELDTERMINATOR = ','
	,ROWTERMINATOR = '\n')
GO


--  Step 3 - Parse data
INSERT INTO 
	[FakeNames].[dbo].[Person_Parsed]
       ([Gender]
       ,[GivenName]
       ,[MiddleInitial]
       ,[Surname]
       ,[StreetAddress]
       ,[City]
       ,[State]
       ,[ZipCode]
       ,[Country]
       ,[EmailAddress]
       ,[Password]
       ,[TelephoneNumber]
       ,[MothersMaiden]
       ,[Birthday]
       ,[CCType]
       ,[CCNumber]
       ,[CVV2]
       ,[CCExpires]
       ,[NationalID]
       ,[UPS]
       ,[Occupation]
       ,[Company]
       ,[Domain]
       ,[BloodType]
       ,[Pounds]
       ,[Kilograms]
       ,[FeetInches]
       ,[Centimeters])
SELECT 
		CASE 
			WHEN [Gender] = 'male' THEN 1
			WHEN [Gender] = 'female' THEN 2
		END
      ,[GivenName]
      ,[MiddleInitial]
      ,[Surname]
      ,[StreetAddress]
      ,[City]
      ,[State]
      ,[ZipCode]
      ,[Country]
      ,[EmailAddress]
      ,[Password]
      ,[TelephoneNumber]
      ,[MothersMaiden]
      ,[Birthday]
      ,[CCType]
      ,[CCNumber]
      ,[CVV2]
      ,'1/' + [CCExpires]
      ,[NationalID]
      ,[UPS]
      ,[Occupation]
      ,[Company]
      ,[Domain]
      ,[BloodType]
      ,[Pounds]
      ,[Kilograms]
      ,[FeetInches]
      ,[Centimeters]
  FROM [FakeNames].[dbo].[Person_Raw]


--  Step 4 - Remove duplicates
--  http://blog.sqlauthority.com/2007/03/01/sql-server-delete-duplicate-records-rows/
DELETE FROM [FakeNames].[dbo].[Person_Parsed]
WHERE [Id] NOT IN
(
	SELECT MIN([Id])
	FROM [FakeNames].[dbo].[Person_Parsed]
	GROUP BY [EmailAddress]
)


--  Step 5 - Copy to [Person]
DELETE FROM [FakeNames].[dbo].[Person]
DBCC CHECKIDENT ('Person', RESEED, 0)

INSERT INTO 
	[FakeNames].[dbo].[Person]
       ([Gender]
       ,[GivenName]
       ,[MiddleInitial]
       ,[Surname]
       ,[StreetAddress]
       ,[City]
       ,[State]
       ,[ZipCode]
       ,[Country]
       ,[EmailAddress]
       ,[Password]
       ,[TelephoneNumber]
       ,[MothersMaiden]
       ,[Birthday]
       ,[CCType]
       ,[CCNumber]
       ,[CVV2]
       ,[CCExpires]
       ,[NationalID]
       ,[UPS]
       ,[Occupation]
       ,[Company]
       ,[Domain]
       ,[BloodType]
       ,[Pounds]
       ,[Kilograms]
       ,[FeetInches]
       ,[Centimeters])
SELECT 
        [Gender]
       ,[GivenName]
       ,[MiddleInitial]
       ,[Surname]
       ,[StreetAddress]
       ,[City]
       ,[State]
       ,[ZipCode]
       ,[Country]
       ,[EmailAddress]
       ,[Password]
       ,[TelephoneNumber]
       ,[MothersMaiden]
       ,[Birthday]
       ,[CCType]
       ,[CCNumber]
       ,[CVV2]
       ,[CCExpires]
       ,[NationalID]
       ,[UPS]
       ,[Occupation]
       ,[Company]
       ,[Domain]
       ,[BloodType]
       ,[Pounds]
       ,[Kilograms]
       ,[FeetInches]
       ,[Centimeters]
  FROM [FakeNames].[dbo].[Person_Parsed]

  
--  Step 6 - Clean up
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Person_Raw]') AND type in (N'U'))
DROP TABLE [dbo].[Person_Raw]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Person_Parsed]') AND type in (N'U'))
DROP TABLE [dbo].[Person_Parsed]
GO

