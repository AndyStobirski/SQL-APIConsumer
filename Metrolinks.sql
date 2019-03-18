/*************************************************************************

Table based functions to access the /MetroLinks and /MetroLinks({id}) apis

*************************************************************************/


/*
	Access the /Metrolinks API
*/


if object_id('dbo.ufnMetroLinks') is not null
	drop function dbo.ufnMetroLinks
go

create function dbo.ufnMetroLinks
(
	@select NVARCHAR (1000)
	--,	@expand NVARCHAR (1000) doesn't offer an expand option
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
		select	*

		from	openjson
				(
					(
						select	[value]
						from	dbo.ufnGetAPIContent('https://api.tfgm.com/odata/Metrolinks', null, @select,@filter,@orderby,@top,@skip,@count)
						where	[key] = 'value'
					)
				)
	WITH (

			Id int '$.Id'
			, Line varchar(255) '$.Line'
			, TLAREF varchar(255) '$.TLAREF'
			, PIDREF varchar(255) '$.PIDREF'
			, StationLocation varchar(255) '$.StationLocation'
			, AtcoCode varchar(255) '$.AtcoCode'
			, Direction varchar(255) '$.Direction'
			, Dest0 varchar(255) '$.Dest0'
			, Carriages0 varchar(255) '$.Carriages0'
			, Status0 varchar(255) '$.Status0'
			, Wait0 varchar(255) '$.Wait0'
			, Dest1 varchar(255) '$.Dest1'
			, Carriages1 varchar(255) '$.Carriages1'
			, Status1 varchar(255) '$.Status1'
			, Wait1 varchar(255) '$.Wait1'
			, Dest2 varchar(255) '$.Dest2'
			, Carriages2 varchar(255) '$.Carriages2'
			, Status2 varchar(255) '$.Status2'
			, Wait2 varchar(255) '$.Wait2'
			, Dest3 varchar(255) '$.Dest3'
			, Carriages3 varchar(255) '$.Carriages3'
			, Status3 varchar(255) '$.Status3'
			, MessageBoard varchar(255) '$.MessageBoard'
			, Wait3 varchar(255) '$.Wait3'
			, LastUpdated DateTime '$.LastUpdated'

		)
	)

go

/*
	return the Metrolinks static data
*/

if object_id('dbo.ufnMetroLinksStatic') is not null
	drop function dbo.ufnMetroLinksStatic
go

create function dbo.ufnMetroLinksStatic
(
	@select NVARCHAR (1000)
	--,	@expand NVARCHAR (1000) doesn't offer an expand option
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
		select	*

		from	openjson
				(
					(
						select	[value]
						from	dbo.ufnGetAPIContent('https://api.tfgm.com/odata/Metrolinks', null, @select,@filter,@orderby,@top,@skip,@count)
						where	[key] = 'value'
					)
				)
	WITH (

			Id int '$.Id'
			, Line varchar(255) '$.Line'
			, TLAREF varchar(255) '$.TLAREF'
			, PIDREF varchar(255) '$.PIDREF'
			, StationLocation varchar(255) '$.StationLocation'
			, AtcoCode varchar(255) '$.AtcoCode'
			, LastUpdated DateTime '$.LastUpdated'

		)
	)

go

/*

	return the Metrolinks static data

*/

if object_id('dbo.ufnMetroLinksDynamic') is not null
	drop function dbo.ufnMetroLinksDynamic
go

create function dbo.ufnMetroLinksDynamic
(
	@select NVARCHAR (1000)
	--,	@expand NVARCHAR (1000) doesn't offer an expand option
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
		select	*

		from	openjson
				(
					(
						select	[value]
						from	dbo.ufnGetAPIContent('https://api.tfgm.com/odata/Metrolinks', null, @select,@filter,@orderby,@top,@skip,@count)
						where	[key] = 'value'
					)
				)
	WITH (

			Id int '$.Id'
			, Direction varchar(255) '$.Direction'
			, Dest0 varchar(255) '$.Dest0'
			, Carriages0 varchar(255) '$.Carriages0'
			, Status0 varchar(255) '$.Status0'
			, Wait0 varchar(255) '$.Wait0'
			, Dest1 varchar(255) '$.Dest1'
			, Carriages1 varchar(255) '$.Carriages1'
			, Status1 varchar(255) '$.Status1'
			, Wait1 varchar(255) '$.Wait1'
			, Dest2 varchar(255) '$.Dest2'
			, Carriages2 varchar(255) '$.Carriages2'
			, Status2 varchar(255) '$.Status2'
			, Wait2 varchar(255) '$.Wait2'
			, Dest3 varchar(255) '$.Dest3'
			, Carriages3 varchar(255) '$.Carriages3'
			, Status3 varchar(255) '$.Status3'
			, MessageBoard varchar(255) '$.MessageBoard'
			, Wait3 varchar(255) '$.Wait3'
			, LastUpdated DateTime '$.LastUpdated'

		)
	)

go


/*
	Access the /Metrolinks({ID}) API
*/

if object_id('dbo.ufnMetroLinksID') is not null
	drop function dbo.ufnMetroLinksID
go

create function dbo.ufnMetroLinksID
(
	@id int
	,	@select NVARCHAR (1000)
)
returns table 
as 
	return 
	(
		select	[key]
				, nullif([value],'') [Value]

		from	OPENJSON([dbo].[ufnTFGM_GetID] ('https://api.tfgm.com/odata/Metrolinks', dbo.ufnGetKey(),@id,null))
	
	)

go

/*	
	Test the values
*/

select *
from	dbo.ufnMetroLinks(null,null,null,null,null,null)

select *
from	dbo.ufnMetroLinksID( 477, null)

select *
from	dbo.ufnMetroLinksStatic(null,null,null,null,null,null)

select *
from	dbo.ufnMetroLinksDynamic(null,null,null,null,null,null)


Select	ID
		, LastUpdated
		, Direction
		, [Key]
		, [Value]

into	dbo.metrolinkactivity

from

(
select *
from	dbo.ufnMetroLinksDynamic(null,null,null,null,null,null)
) p

unpivot ([Value] for [Key] in 
			(Dest0, Carriages0, Status0,Wait0,Dest1, Carriages1, Status1,Wait1, Dest2, Carriages2, Status2,Wait2, Dest3, Carriages3, Status3,Wait3)
		) as unpvt

where	[Value] != ''