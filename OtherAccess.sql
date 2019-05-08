/*

	Access the /Accidents API

*/
if object_id('dbo.ufnAccidents') is not null
	drop function dbo.ufnAccidents
go

create function dbo.ufnAccidents
(
	@select NVARCHAR (1000)
	,	@expand NVARCHAR (1000)
	,	@filter NVARCHAR (1000)
	,	@orderby NVARCHAR (100)
	,	@top NVARCHAR (10) 
	,	@skip NVARCHAR (10)
	,	@count NVARCHAR (10) 
)
returns table as

return
(
select	[Id]
		, [SCN]
		, [Type]
		, [Description]
		, [LocationDescription]
		, [CreationDate]
		, [ConfirmedDate]
		, [ModifiedDate]
		, [LanesAffectedTypeRefDescription]
		, [Severity]
		, [PhaseTypeRef]
		, [DiversionInForce]
		, [AnticipatedStartDate]
		, [AnticipatedEndDate]
		, [StartDate]
		, [EndDate]
		, [TrafficSignals]
		, [Contraflow]
		, [Contractor]
		, [DiversionRoute]
		, [Organiser]
		, [VenueName]
		, [LocationId]
		, [TrafficeEventType]
		, locCoords.*

		from	openjson
				(
					(
						select	[value]
						from	dbo.ufnGetAPIContent('https://api.tfgm.com/odata/Accidents', @expand, @select,@filter,@orderby,@top,@skip,@count)
						where	[key] = 'value'
					)
				)

with

		(

			[Id] int '$.Id'
			, [SCN] varchar(255) '$.SCN'
			, [Type] varchar(255) '$.Type'
			, [Description] varchar(255) '$.Description'
			, [LocationDescription] varchar(255) '$.LocationDescription'
			, [CreationDate] DateTime '$.CreationDate'
			, [ConfirmedDate] DateTime '$.ConfirmedDate'
			, [ModifiedDate] DateTime '$.ModifiedDate'
			, [LanesAffectedTypeRefDescription] varchar(255) '$.LanesAffectedTypeRefDescription'
			, [Severity] varchar(255) '$.Severity'
			, [PhaseTypeRef] varchar(255) '$.PhaseTypeRef'
			, [DiversionInForce] bit '$.DiversionInForce'
			, [AnticipatedStartDate] DateTime '$.AnticipatedStartDate'
			, [AnticipatedEndDate] DateTime '$.AnticipatedEndDate'
			, [StartDate] DateTime '$.StartDate'
			, [EndDate] DateTime '$.EndDate'
			, [TrafficSignals] bit '$.TrafficSignals'
			, [Contraflow] bit '$.Contraflow'
			, [Contractor] varchar(255) '$.Contractor'
			, [DiversionRoute] varchar(255) '$.DiversionRoute'
			, [Organiser] varchar(255) '$.Organiser'
			, [VenueName] varchar(255) '$.VenueName'
			, [LocationId] int '$.LocationId'
			, [TrafficeEventType] varchar(255) '$.TrafficeEventType'
			, [WellKnownText] nvarchar(max) '$.Location.LocationSpatial.Geography.WellKnownText'

		)
		outer apply dbo.ufnGetLocationCoords([WellKnownText]) locCoords

)

go

select	*
from	dbo.ufnAccidents('id','Location',null,null,null,null,null)

/*

	Access the /VenueEvents API

*/
if object_id('dbo.ufnVenueEvents') is not null
	drop function dbo.ufnVenueEvents
go

create function dbo.ufnVenueEvents
(
	@select NVARCHAR (1000)
	,	@expand NVARCHAR (1000)
	,	@filter NVARCHAR (1000)
	,	@orderby NVARCHAR (100)
	,	@top NVARCHAR (10) 
	,	@skip NVARCHAR (10)
	,	@count NVARCHAR (10) 
)
returns table as

return
(
select	[Id]
		, [SCN]
		, [Type]
		, [Description]
		, [LocationDescription]
		, [CreationDate]
		, [ConfirmedDate]
		, [ModifiedDate]
		, [LanesAffectedTypeRefDescription]
		, [Severity]
		, [PhaseTypeRef]
		, [DiversionInForce]
		, [AnticipatedStartDate]
		, [AnticipatedEndDate]
		, [StartDate]
		, [EndDate]
		, [TrafficSignals]
		, [Contraflow]
		, [Contractor]
		, [DiversionRoute]
		, [Organiser]
		, [VenueName]
		, [LocationId]
		, [TrafficeEventType]
		, locCoords.*

		from	openjson
				(
					(
						select	[value]
						from	dbo.ufnGetAPIContent('https://api.tfgm.com/odata/VenueEvents', @expand, @select,@filter,@orderby,@top,@skip,@count)
						where	[key] = 'value'
					)
				)

with

		(

			[Id] int '$.Id'
			, [SCN] varchar(255) '$.SCN'
			, [Type] varchar(255) '$.Type'
			, [Description] varchar(255) '$.Description'
			, [LocationDescription] varchar(255) '$.LocationDescription'
			, [CreationDate] DateTime '$.CreationDate'
			, [ConfirmedDate] DateTime '$.ConfirmedDate'
			, [ModifiedDate] DateTime '$.ModifiedDate'
			, [LanesAffectedTypeRefDescription] varchar(255) '$.LanesAffectedTypeRefDescription'
			, [Severity] varchar(255) '$.Severity'
			, [PhaseTypeRef] varchar(255) '$.PhaseTypeRef'
			, [DiversionInForce] bit '$.DiversionInForce'
			, [AnticipatedStartDate] DateTime '$.AnticipatedStartDate'
			, [AnticipatedEndDate] DateTime '$.AnticipatedEndDate'
			, [StartDate] DateTime '$.StartDate'
			, [EndDate] DateTime '$.EndDate'
			, [TrafficSignals] bit '$.TrafficSignals'
			, [Contraflow] bit '$.Contraflow'
			, [Contractor] varchar(255) '$.Contractor'
			, [DiversionRoute] varchar(255) '$.DiversionRoute'
			, [Organiser] varchar(255) '$.Organiser'
			, [VenueName] varchar(255) '$.VenueName'
			, [LocationId] int '$.LocationId'
			, [TrafficeEventType] varchar(255) '$.TrafficeEventType'
			, [WellKnownText] nvarchar(max) '$.Location.LocationSpatial.Geography.WellKnownText'

		)
		outer apply dbo.ufnGetLocationCoords([WellKnownText]) locCoords

)

go

select	*
from	dbo.ufnVenueEvents(null,'Location',null,null,null,null,null)



/*

	Access the /Incidents API

*/
if object_id('dbo.ufnIncidents') is not null
	drop function dbo.ufnIncidents
go

create function dbo.ufnIncidents
(
	@select NVARCHAR (1000)
	,	@expand NVARCHAR (1000)
	,	@filter NVARCHAR (1000)
	,	@orderby NVARCHAR (100)
	,	@top NVARCHAR (10) 
	,	@skip NVARCHAR (10)
	,	@count NVARCHAR (10) 
)
returns table as

return
(
select	[Id]
		, [SCN]
		, [Type]
		, [Description]
		, [LocationDescription]
		, [CreationDate]
		, [ConfirmedDate]
		, [ModifiedDate]
		, [LanesAffectedTypeRefDescription]
		, [Severity]
		, [PhaseTypeRef]
		, [DiversionInForce]
		, [AnticipatedStartDate]
		, [AnticipatedEndDate]
		, [StartDate]
		, [EndDate]
		, [TrafficSignals]
		, [Contraflow]
		, [Contractor]
		, [DiversionRoute]
		, [Organiser]
		, [VenueName]
		, [LocationId]
		, [TrafficeEventType]
		, locCoords.*

		from	openjson
				(
					(
						select	[value]
						from	dbo.ufnGetAPIContent('https://api.tfgm.com/odata/Incidents', null, @select,@filter,@orderby,@top,@skip,@count)
						where	[key] = 'value'
					)
				)

with

		(

			[Id] int '$.Id'
			, [SCN] varchar(255) '$.SCN'
			, [Type] varchar(255) '$.Type'
			, [Description] varchar(255) '$.Description'
			, [LocationDescription] varchar(255) '$.LocationDescription'
			, [CreationDate] DateTime '$.CreationDate'
			, [ConfirmedDate] DateTime '$.ConfirmedDate'
			, [ModifiedDate] DateTime '$.ModifiedDate'
			, [LanesAffectedTypeRefDescription] varchar(255) '$.LanesAffectedTypeRefDescription'
			, [Severity] varchar(255) '$.Severity'
			, [PhaseTypeRef] varchar(255) '$.PhaseTypeRef'
			, [DiversionInForce] bit '$.DiversionInForce'
			, [AnticipatedStartDate] DateTime '$.AnticipatedStartDate'
			, [AnticipatedEndDate] DateTime '$.AnticipatedEndDate'
			, [StartDate] DateTime '$.StartDate'
			, [EndDate] DateTime '$.EndDate'
			, [TrafficSignals] bit '$.TrafficSignals'
			, [Contraflow] bit '$.Contraflow'
			, [Contractor] varchar(255) '$.Contractor'
			, [DiversionRoute] varchar(255) '$.DiversionRoute'
			, [Organiser] varchar(255) '$.Organiser'
			, [VenueName] varchar(255) '$.VenueName'
			, [LocationId] int '$.LocationId'
			, [TrafficeEventType] varchar(255) '$.TrafficeEventType'
			, [WellKnownText] nvarchar(max) '$.Location.LocationSpatial.Geography.WellKnownText'

		)
		outer apply dbo.ufnGetLocationCoords([WellKnownText]) locCoords

)

go

select	*
from	dbo.ufnIncidents(null,'Location',null,null,null,null,null)

/*

	Carparks

*/

if object_id('dbo.ufnCarparks') is not null
	drop function dbo.ufnCarparks
go

create function dbo.ufnCarparks
(
	@select NVARCHAR (1000)
	,	@expand NVARCHAR (1000)
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


		select	[Id]
				, [State]
				, [SCN]
				, [Capacity]
				, [Description]
				, [Occupancy]
				, [LastUpdated]
				, [LocationId]
				, locCoords.*

		from	openjson
				(
					(
						select	[value]
						from	dbo.ufnGetAPIContent('https://api.tfgm.com/odata/Carparks', 'Location', @select,@filter,@orderby,@top,@skip,@count)
						where	[key] = 'value'
					)
				)

		with 

				(
					[Id] int '$.Id'
					, [State] varchar(255) '$.State'
					, [SCN] varchar(255) '$.SCN'
					, [Capacity] int '$.Capacity'
					, [Description] varchar(255) '$.Description'
					, [Occupancy] int '$.Occupancy'
					, [LastUpdated] DateTime '$.LastUpdated'
					, [LocationId] int '$.LocationId'
					, [WellKnownText] nvarchar(100) '$.Location.LocationSpatial.Geography.WellKnownText'
				)
				outer apply dbo.ufnGetLocationCoords([WellKnownText]) locCoords
	)
	
go


/*

	dbo.ufnCarparksDynamic

	Get the changing components of carparks
*/
if object_id('dbo.ufnCarparksDynamic') is not null
	drop function dbo.ufnCarparksDynamic
go

create function dbo.ufnCarparksDynamic()

returns table 
as
	return
	(
		select	id
				, capacity
				, [state]

		from	dbo.ufnCarparks(null,null,null,null,null,null,null)
	)
go

/*

	dbo.ufnCarparksDynamic

	Get the static components of carparks
*/
if object_id('dbo.ufnCarparksStatic') is not null
	drop function dbo.ufnCarparksStatic
go

create function dbo.ufnCarparksStatic()

returns table 
as
	return
	(
		select	id
				, scn
				, [description]
				, capacity

		from	dbo.ufnCarparks(null,null,null,null,null,null,null)
	)
go




select	*
from	dbo.ufnCarparks(null,'Location',null,null,null,null,null)
order by LastUpdated desc

select	*
from	dbo.ufnCarparksDynamic()

select	*
from	dbo.ufnCarparksStatic()


/*

	dbo.ufnScootLoops

	Get /ScootLoops
*/

if object_id('dbo.ufnScootLoops') is not null
	drop function dbo.ufnScootLoops
go

create function dbo.ufnScootLoops
(
	@select NVARCHAR (1000)
	,	@expand NVARCHAR (1000)
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
		select	[Id]
				, [SCN]
				, [Description]
				, [LastUpdated]
				, StartLocation.Longitude as StartLong
				, StartLocation.Latitude as StartLat
				, EndLocation.Longitude as EndLong
				, EndLocation.Latitude as EndLat
				, DetailsCongestionPercentage
				, DetailsCurrentFlow
				, DetailsAverageSpeed
				, DetailsLinkStatus
				, DetailsLinkTravelTime

		from	openjson
				(
					(
						select	[value]
						from	dbo.ufnGetAPIContent('https://api.tfgm.com/odata/ScootLoops', @expand, @select, @filter,@orderby,@top,@skip,@count)
						where	[key] = 'value'
					)
				)

		with 

				(

					[Id] int 'strict$.Id'
					, [SCN] varchar(255) '$.SCN'
					, [Description] varchar(255) '$.Description'
					, [LastUpdated] DateTime '$.LastUpdated'
					, StartLocation nvarchar(100) '$.StartLocation.LocationSpatial.Geography.WellKnownText'
					, EndLocation nvarchar(100) '$.EndLocation.LocationSpatial.Geography.WellKnownText'
					, ScootDetails nvarchar(max) '$.ScootDetails' as json
				)
				outer apply dbo.ufnGetLocationCoords(StartLocation) StartLocation
				outer apply dbo.ufnGetLocationCoords(EndLocation) EndLocation
				outer apply openjson(ScootDetails)
				with
				(
					DetailsCongestionPercentage int '$.CongestionPercentage'
					, DetailsCurrentFlow int '$.CurrentFlow'
					, DetailsAverageSpeed int '$.AverageSpeed'
					, DetailsLinkStatus int '$.LinkStatus'
					, DetailsLinkTravelTime int '$.LinkTravelTime'
				)
	)

go

/*

	dbo.ufnScootLoopsStatic

*/

if object_id('dbo.ufnScootLoopsStatic') is not null
	drop function dbo.ufnScootLoopsStatic
go

create function dbo.ufnScootLoopsStatic ()
returns table 
as
return
	(

		select	[Id]
				, [SCN]
				, [Description]
				, [LastUpdated]
				, StartLong
				, StartLat
				, EndLong
				, EndLat

		from	dbo.ufnScootLoops(null,'EndLocation,StartLocation,',null,null,null,null,null)


	)

go

/*

	dbo.ufnScootLoopsDynamic

*/

if object_id('dbo.ufnScootLoopsDynamic') is not null
	drop function dbo.ufnScootLoopsDynamic
go

create function dbo.ufnScootLoopsDynamic ()
returns table 
as
return
	(

		select	[Id]
				, DetailsCongestionPercentage
				, DetailsCurrentFlow
				, DetailsAverageSpeed
				, DetailsLinkStatus
				, DetailsLinkTravelTime


		from	dbo.ufnScootLoops(null,'ScootDetails',null,null,null,null,null)


	)

go


	select	*
	from	dbo.ufnScootLoops(null,'EndLocation,StartLocation,ScootDetails',null,null,null,null,null)

	select	*
	from	dbo.ufnScootLoopsStatic ()

	select	*
	from	dbo.ufnScootLoopsDynamic ()

/*

	Traffic Signals

*/


drop table if exists [dbo].[TrafficSignals]

go

CREATE TABLE [dbo].[TrafficSignals](
	[Id] [int] NULL,
	[SCN] [varchar](255) NULL,
	[Description] [varchar](255) NULL,
	[DataSource] [varchar](255) NULL,
	[RoadName] [varchar](255) NULL,
	[DateCreated] [datetime] NULL,
	[LocationID] [int] NULL,
	[StartLong] [float] NULL,
	[StartLat] [float] NULL
) ON [PRIMARY]
GO

/*

	dbo.ufnTrafficSignals

*/
drop function if exists [dbo].ufnTrafficSignals

go

create function dbo.ufnTrafficSignals
(
	@select NVARCHAR (1000)
	,	@expand NVARCHAR (1000)
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
		select	[Id]
				, [SCN]
				, [Description]
				, [DataSource]
				, [RoadName]
				, [DateCreated]
				, [LocationID]
				, [Location].Longitude as StartLong
				, [Location].Latitude as StartLat

		from	openjson
				(
					(
						select	[value]
						from	dbo.ufnGetAPIContent('https://api.tfgm.com/odata/TrafficSignals', @expand, @select, @filter,@orderby,@top,@skip,@count)
						where	[key] = 'value'
					)
				)

		with 

				(

					[Id] int 'strict$.Id'
					, [SCN] varchar(255) '$.SCN'
					, [Description] varchar(255) '$.Description'
					, [DataSource] varchar(255) '$.DataSource'
					, [RoadName] varchar(255) '$.RoadName'
					, [DateCreated] datetime '$.DateCreated'
					, [LocationID] int '$.LocationID'
					, [Location] nvarchar(100) '$.Location.LocationSpatial.Geography.WellKnownText'

				)
				outer apply dbo.ufnGetLocationCoords([Location]) Location

		)

go
