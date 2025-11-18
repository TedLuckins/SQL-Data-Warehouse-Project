-- Creates a Database and Schemas

USE Master
GO
-- ===================================================
-- WARNING! Drops any Database called 'DataWarehouse'
-- ===================================================
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


