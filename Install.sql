/*

	TfGMSQLAccess installation script
	


*/

sp_configure 'clr enabled',1
RECONFIGURE

go

ALTER DATABASE TFGM SET TRUSTWORTHY ON

--drop the assembly dependant functions first
drop function if exists [dbo].ufnTFGM_Get
drop function if exists [dbo].ufnTFGM_GetID

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
drop table if exists dbo.tfgmKey

go
create table dbo.tfgmKey
(
	APIkey varchar(100)
)
go


/*
	Scalar function which returns the key
*/

drop function if exists dbo.ufnGetKey
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
drop function if exists [dbo].ufnGetAPIContent
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
returns @ret table
(
	[key] nvarchar(4000)
	, [value] nvarchar(max)
	, [type] tinyint
)
as
	begin
	
		declare @json as varchar(max) = [dbo].[ufnTFGM_Get] (@URL, dbo.ufnGetKey(),@expand,@select,@filter,@orderby,@top,@skip,@count)

		if ISJSON(@json) = 1

			begin

				insert into @ret
				(
					[key]
					, [value]
					, [type]
				)

				SELECT	[key]
						, [value]
						, [type]

				FROM	OPENJSON(@json)

			end

		else

			begin

				insert into @ret
				(
					[key]
					, [value]
					, [type]
				)

				select	'error'
						, @json
						, 1	--string value

			end

		return

	end
go

/*

	dbo.ufnGetLocationCoords

*/
drop function if exists [dbo].ufnGetLocationCoords
go

create function [dbo].ufnGetLocationCoords(@WellKnownText varchar(100))
/*
	
	Split the contents of the entry "WellKnownText" into long and lat

	This is derived from a location entry

	e.g. 

		https://api.tfgm.com/odata/Accidents?$expand=Location&$top=2

		returns an array of trafficevents items, each with the child

		"Location": {
			  "Id": 38831250,
			  "LocationSpatial": {
				"Geography": {
				  "CoordinateSystemId": 4326,
				  "WellKnownText": "POINT (-2.16602264021093 53.5857669129475)",
				  "WellKnownBinary": null
				}
			  }

*/

returns @ret table
(
	Longitude float
	, Latitude float
)
as
begin

	--declare @sub varchar(100) = 'POINT (-2.16602264021093 53.5857669129475)' --long,lat
	declare @strip as varchar(100) = substring (@WellKnownText, CHARINDEX('(', @WellKnownText)+1,CHARINDEX(')', @WellKnownText)- CHARINDEX('(', @WellKnownText)-1)

		insert into @ret (Longitude, Latitude)
		values 
		(	
			substring(@strip, 0, charindex(' ', @strip))
			, substring(@strip, charindex(' ', @strip),100)
		)

return 
end
