CREATE TABLE [dbo].[ExchangeTable]
(
	[productionLineId] INT NOT NULL PRIMARY KEY, 
    [workOrderId] INT NULL, 
    [workOrder] NCHAR(6) NULL, 
    [partNumberId] INT NULL, 
    [partNumber] NCHAR(16) NULL, 
    [measuredPartId] BIGINT NULL, 
    [measurementValid] BIT NULL, 
    [workOrderSize] SMALLINT NULL
)

GO

CREATE TRIGGER [dbo].[Trigger_ExchangeTableAfterUpdate]
    ON [dbo].[ExchangeTable]
    AFTER UPDATE
    AS
    BEGIN
        SET NoCount ON;
		IF ((SELECT [workOrderSize] FROM [inserted]) != (SELECT [workOrderSize] FROM [deleted]) OR (SELECT [workOrderSize] FROM [deleted]) IS NULL) AND (SELECT [workOrderSize] FROM [inserted]) IS NOT NULL
			BEGIN
				UPDATE [WorkOrder]
				SET [size] = (SELECT [workOrderSize] FROM [inserted])
				WHERE [id] = (SELECT [workOrderId] FROM [inserted]);
			END
    END