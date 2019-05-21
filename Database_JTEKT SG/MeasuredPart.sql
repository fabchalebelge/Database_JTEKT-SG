CREATE TABLE [dbo].[MeasuredPart]
(
	[id] BIGINT NOT NULL PRIMARY KEY IDENTITY, 
    [workOrderId] INT NULL , 
    [timeStamp] DATETIME NULL DEFAULT GetDate(), 
    [valid] BIT NULL, 
    CONSTRAINT [FK_MeasuredPart_workOrderId] FOREIGN KEY ([workOrderId]) REFERENCES [WorkOrder]([id]) 
)

GO

CREATE INDEX [IX_MeasuredPart_timeStamp] ON [dbo].[MeasuredPart] ([timeStamp])

GO


CREATE TRIGGER [dbo].[Trigger_MeasuredPartAfterInsert]
    ON [dbo].[MeasuredPart]
    AFTER INSERT
    AS
    BEGIN
		DECLARE
			@myWoQty int,
			@myWoId int = (SELECT [workOrderId] FROM [inserted]);
        SET NoCount ON;
		SELECT @myWoQty = COUNT([id]) FROM [MeasuredPart] WHERE [workOrderId] = @myWoId;
		UPDATE [WorkOrder] SET [numOfPieces] = @myWoQty WHERE [id] = @myWoId;
    END
GO

CREATE TRIGGER [dbo].[Trigger_MeasuredPartAfterUpdate]
    ON [dbo].[MeasuredPart]
    AFTER UPDATE
    AS
    BEGIN
        DECLARE
			@myWoQtyOk int,
			@myWoQtyNok int,
			@myWoId int = (SELECT [workOrderId] FROM [inserted]);
        SET NoCount ON;
		SELECT @myWoQtyOk = SUM(CAST([valid] AS tinyint)), @myWoQtyNok = COUNT([valid]) - SUM(CAST([valid] AS tinyint)) FROM [MeasuredPart] WHERE [workOrderId] = @myWoId;
		UPDATE [WorkOrder] SET [numOfPiecesOk] = @myWoQtyOk, [numOfPiecesNok] = @myWoQtyNok, [timeStampStop] = GETDATE() WHERE [id] = @myWoId;
    END