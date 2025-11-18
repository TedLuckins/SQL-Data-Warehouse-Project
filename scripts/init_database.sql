/*
Creates a Database and Schemas
Script Purpose: 
	Script Checks for existing database with the name 'DataWarehouse', if this data base exist already it will be dropped and a new database will replace it, 
	if not found it will create a new database.
	The New database will contain 3 schemas: 'bronze', 'silver' and 'gold'.

===============================================================================
WARNING! This script will drop any pre-existing database named 'DataWarehouse'
===============================================================================
*/
USE Master
GO

IF EXISTS (SELECT 1 FROM sys.Databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWareHouse
END;
GO

-- Creates Database 'DataWarehouse'
CREATE DATABASE DataWareHouse;
GO

USE DataWareHouse;
GO


-- Create Schemas
Create SCHEMA bronze;
GO

Create SCHEMA silver;
GO

Create SCHEMA gold;
GO


