CREATE TABLE [dbo].[Config]
(
	[id] INT NOT NULL PRIMARY KEY, 
    [parameter] NVARCHAR(MAX) NULL, 
    [value] NVARCHAR(MAX) NULL
)
