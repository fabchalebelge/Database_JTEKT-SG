CREATE TABLE [dbo].[Log]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [productionLineId] INT NULL, 
    [partNumberId] INT NULL , 
    [dimensionId] INT NULL , 
    [timeStamp] DATETIME NULL DEFAULT GetDate(), 
    [log] nvarchar(MAX) NULL 
)

GO

CREATE INDEX [IX_Log_timeStamp] ON [dbo].[Log] ([timeStamp])

GO
