# TfGMSQLAccess

This is a project forked from [Geraldo Diaz's](https://github.com/geral2) [geral2/SQL-APIConsumer project](https://github.com/geral2/SQL-APIConsumer). It is intended to do just one thing: access data from [Transport for Greater Manchester’s new Real-Time Open Data Portal](https://developer.tfgm.com/), so I examined Geraldo's excellent code and cut out all the bits I didn't need and made some minor modifications.

When installed, it offers one feature - a function used to query the TFGM apis and return the entire API's output in the form of an NVARCHAR(MAX).

Like the software it is forked from it was developed and tested on **SQL Server 2016 and later versions**.

For more details information, refer to [Geraldo Diaz's](https://github.com/geral2) original project [geral2/SQL-APIConsumer project](https://github.com/geral2/SQL-APIConsumer)

**To use this code you will need to registered an account at [https://developer.tfgm.com/](https://developer.tfgm.com/) in order to obtain a Ocp-Apim-Subscription-Key which is required in order to access the API.**

## Getting Started

This project has one stored procedure:

**ufnTFGM_Get(SqlString @URL, SQLString @OcpApimSubscriptionKey)**

Where **@URL** is the address of the TFGM Api being requested and **OcpApimSubscriptionKey** is the subscription key provided by TFGM after registering with the service.

PD:
It uses HttpWebRequest instead of HttpClient in order to avoid having to use unsupported assemblies by SQL Server.

### Prerequisites

Before you deploy the CLR you should set up some configuration in your SQL instance.

###### **STEP 1**
Confirm that your have enable this option 'clr enabled'.

```
USE TestDB
GO
sp_configure 'clr enabled',1
RECONFIGURE
```
###### **STEP 2**
Set your database to TRUSTWORTHY mode on.

```
ALTER DATABASE TESTDB SET TRUSTWORTHY ON
```
###### **STEP 3**
Copy CLR entire folder to disk C:\ or an alernative path that do you want.

```
C:\CLR
```
### Installing

Now we are ready to install (create) the clr objects of SQL-APIConsumer. Let's do it!.


###### **STEP 1**
First, Let's create our Assembly:

```
CREATE ASSEMBLY [API_Consumer]
AUTHORIZATION dbo
FROM  N'C:\CLR\API_Consumer.dll'
WITH PERMISSION_SET = UNSAFE
```
###### **STEP 2**
After that we can create our CLR Stored procedures:

```
create function [dbo].[ufnTFGM_Get] 
(
	@URL NVARCHAR (MAX) NULL
	,@OcpApimSubscriptionKey NVARCHAR (MAX) NULL
)
returns nvarchar(max)
AS EXTERNAL NAME [API_Consumer].[Functions].[UfnTFGM_Get]

```

### **Sample of calling Get Method**
-- How to consume GET API
-- How to show Json results.

```
declare @url varchar(max) = 'https://api.tfgm.com/odata/Metrolinks?$top=2'
declare @OcpApimSubscriptionKey varchar(max) = 'XXXXXXXXXXXXXXXXXXXXXXXXXX'
declare	@context as nvarchar(max)
declare @Results as nvarchar(max)

select @context = [dbo].[ufnTFGM_Get] (@URL, @OcpApimSubscriptionKey)

--just want the values
SELECT	@Results = [value]
FROM	OPENJSON(@context)
where	[key] = 'value'

--outputs three columns: key, value and type
select	*
from	openjson(@Results)

```


## Deployment

Make sure that the user on your SQL Server instance have grant access to CLR Folder where you stored the files.

## Authors

* **Geraldo Diaz** - *SQL Developer* - [geral2](https://github.com/geral2)

See also the list of [contributors](https://github.com/geral2/SQL-APIConsumer/projects/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/geral2/SQL-APIConsumer/blob/master/LICENSE) file for details

## Acknowledgments

* **Geraldo Diaz** - *Original Author* - [geral2](https://github.com/geral2)
