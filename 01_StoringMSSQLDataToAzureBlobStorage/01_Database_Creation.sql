USE [Master];
GO


IF EXISTS (SELECT * FROM sys.credentials WHERE name = 'https://storaccdatafilesmssql.blob.core.windows.net/mymssqlfile')
DROP CREDENTIAL [https://xxxxx.blob.core.windows.net/mymssqlfile] 

CREATE CREDENTIAL [https://xxxxxx.blob.core.windows.net/mymssqlfile] 
WITH
IDENTITY = 'SHARED ACCESS SIGNATURE', 
SECRET = 'sv=xxxxxxxxxxxx'
GO


CREATE DATABASE [myMSSQLinAzure]
ON (
NAME = 'mymssqlinazure',
FILENAME = 'https://xxxx.blob.core.windows.net/mymssqlfile/mymssqlinazure.mdf' 
)
LOG ON (
NAME = 'mymssqlinazure_log',
FILENAME = 'https://xxxxx.blob.core.windows.net/mymssqlfile/mymssqlinazure.ldf' 
);
GO



USE [myMSSQLinAzure]
GO

CREATE TABLE dbo.sampleData
(ID INT IDENTITY(1,1)
,someText VARCHAR(200)
,someNmr INT
)

INSERT INTO dbo.sampleData (someText, someNmr)
 		  SELECT 'adding Table to Azure Storage', 10
UNION ALL SELECT 'adding files to Blob storage', 100



SELECT * FROM dbo.sampleData