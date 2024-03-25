USE [AdventureWorks2012]
GO

/****** Object:  Index [IX_Address_StateProvinceID]    Script Date: 4/8/2012 8:18:19 PM ******/
DROP INDEX [IX_Address_StateProvinceID] ON [Person].[Address]
GO


/****** Object:  Index [IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode]    Script Date: 4/8/2012 8:18:31 PM ******/
DROP INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode] ON [Person].[Address]
GO

/****** Object:  Index [AK_Address_rowguid]    Script Date: 4/8/2012 8:18:43 PM ******/
DROP INDEX [AK_Address_rowguid] ON [Person].[Address]
GO

