﻿/*

	TfGMSQLAccess installation script
	


*/

sp_configure 'clr enabled',1
RECONFIGURE

go

ALTER DATABASE TFGM SET TRUSTWORTHY ON

--drop the assembly dependant functions first
if object_id('dbo.ufnTFGM_Get') is not null
	drop function dbo.ufnTFGM_Get

if object_id('dbo.ufnTFGM_GetID') is not null
	drop function dbo.ufnTFGM_GetID

go

--drop and create the assembly 
if exists (	select	*
	from	sys.assemblies a
	where	[name] = 'TfGMSQLAccess')
	drop ASSEMBLY TfGMSQLAccess


create ASSEMBLY TfGMSQLAccess
AUTHORIZATION dbo
FROM  N'C:\clr\TfGMSQLAccess.dll'
WITH PERMISSION_SET = UNSAFE

GO

/*
	Function to access the API which returns entire response as a nvarchar(max)
*/
create function [dbo].[ufnTFGM_Get] 
(
	@URL NVARCHAR (500) NULL
	,	@OcpApimSubscriptionKey NVARCHAR (100) NULL
	,	@expand NVARCHAR (1000) null
	,	@select NVARCHAR (1000) null
	,	@filter NVARCHAR (1000) null
	,	@orderby NVARCHAR (100) null
	,	@top NVARCHAR (10) null
	,	@skip NVARCHAR (10) null
	,	@count NVARCHAR (10) null

)
returns nvarchar(max)
AS EXTERNAL NAME [TfGMSQLAccess].[Functions].[UfnTFGM_Get]

go
/*
	Function to access the API which returns entire response as a nvarchar(max)
*/
create function [dbo].[ufnTFGM_GetID] 
(
	@URL NVARCHAR (500) NULL
	,	@OcpApimSubscriptionKey NVARCHAR (100) NULL
	,	@id int  null
	,	@select NVARCHAR (1000) null


)
returns nvarchar(max)
AS EXTERNAL NAME [TfGMSQLAccess].[Functions].[UfnTFGM_GetID]

go
/*
	Store the key here
*/
if object_id('dbo.tfgmKey') is not null
	drop table dbo.tfgmKey
go
create table dbo.tfgmKey
(
	APIkey varchar(100)
)
go


/*
	Scalar function which returns the key
*/

if object_id('dbo.ufnGetKey') is not null
	drop function dbo.ufnGetKey
go

create function dbo.ufnGetKey()
returns varchar(100)
as 
	begin
		
		declare @key as varchar(100)

		select	@key = APIkey
		from	 dbo.tfgmKey

		return @key
	end
go


/*
	First stage wrapper which breaks the returned JSON in key / value pair
*/
if object_id('dbo.ufnGetAPIContent') is not null
	drop function dbo.ufnGetAPIContent
go

create function dbo.ufnGetAPIContent(
	@url varchar(max)
	,	@expand NVARCHAR (1000)
	,	@select NVARCHAR (1000)
	,	@filter NVARCHAR (1000)
	,	@orderby NVARCHAR (100)
	,	@top NVARCHAR (10) 
	,	@skip NVARCHAR (10)
	,	@count NVARCHAR (10) 
)
returns table
as 
	return
	(		
		SELECT	*
		FROM	OPENJSON([dbo].[ufnTFGM_Get] (@URL, dbo.ufnGetKey(),@expand,@select,@filter,@orderby,@top,@skip,@count))
	)
go
