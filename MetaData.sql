declare @retval nvarchar(max)

set @retval = 
	[dbo].[ufnTFGM_Get] ('https://api.tfgm.com/odata/$metadata', dbo.ufnGetKey(),null,null,null,null,null,null,null)

/*
	for some reason, the XML header ends in a question mark
	e.g. <?xml version="1.0" encoding="utf-8"?>

	Which breaks the convert
*/

declare @xml as xml = convert(xml, ltrim(substring(@retval, len('<?xml version="1.0" encoding="utf-8"?>')+1, len(@retval))))


DECLARE @metadata TABLE ( ID INT, tag XML )
INSERT  INTO @metadata	(tag ) VALUES  (@xml) 


/*
	Return datatypes
*/
;WITH XMLNAMESPACES( 'http://docs.oasis-open.org/odata/ns/edmx' as edmx

					, default 'http://docs.oasis-open.org/odata/ns/edm')

SELECT  distinct TableName = et.value('@Name', 'varchar(100)') 
		, TableID = et.value('for $i in . return count(../*[. << $i]) + 1', 'int')
        , ColName = p.value('@Name', 'varchar(100)') 
		, ColType = p.value('@Type', 'varchar(100)') 
		, ColNull = isnull(p.value('@Nullable', 'varchar(100)') ,'true')		
		--https://stackoverflow.com/a/9863151/500181
		, ColOrd = p.value('for $i in . return count(../*[. << $i])', 'int')--don't have the +1 here, as the first node of entityType is always Key

FROM    @metadata t
        CROSS APPLY tag.nodes('/edmx:Edmx/edmx:DataServices/Schema/EntityType') AS tab ( et )   
		CROSS APPLY tab.et.nodes('Property') AS props ( p )


/*
	Expandable properties
*/

;WITH XMLNAMESPACES( 'http://docs.oasis-open.org/odata/ns/edmx' as edmx
					, default 'http://docs.oasis-open.org/odata/ns/edm')

SELECT  distinct TableName = et.value('@Name', 'varchar(100)') 
		, TableID = et.value('for $i in . return count(../*[. << $i]) + 1', 'int')
		, Property = p.value('@Name', 'varchar(100)')
		, [Type] = p.value('@Type', 'varchar(100)')

FROM    @metadata t
        CROSS APPLY tag.nodes('/edmx:Edmx/edmx:DataServices/Schema/EntityType') AS tab ( et )   
		CROSS APPLY tab.et.nodes('NavigationProperty') AS props ( p )




/*
	Get enums
*/
;WITH XMLNAMESPACES( 'http://docs.oasis-open.org/odata/ns/edmx' as edmx
					, default 'http://docs.oasis-open.org/odata/ns/edm')

SELECT  distinct EnumName = et.value('@Name', 'varchar(100)') 
		, EnumName = p.value('@Name', 'varchar(100)')
		, EnumValue = p.value('@Value', 'varchar(100)')

FROM    @metadata t
        CROSS APPLY tag.nodes('/edmx:Edmx/edmx:DataServices/Schema/EnumType') AS tab ( et )   
		CROSS APPLY tab.et.nodes('Member') AS props ( p )