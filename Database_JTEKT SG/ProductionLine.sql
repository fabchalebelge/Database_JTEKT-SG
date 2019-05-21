CREATE TABLE [dbo].[ProductionLine]
(
	[id] INT NOT NULL PRIMARY KEY, 
    [productionLine] NCHAR(4) NULL
)

GO

CREATE INDEX [IX_ProductionLine_productionLine] ON [dbo].[ProductionLine] ([productionLine])

GO

CREATE TRIGGER [dbo].[Trigger_ProductionLineAfterInsert]
    ON [dbo].[ProductionLine]
    AFTER INSERT
    AS
    BEGIN
        SET NoCount ON;

		DECLARE @log nvarchar(MAX), @id int, @productionLine char(4);

		DECLARE productionLine_cursor CURSOR FOR SELECT [i].[id], [i].[productionLine] FROM [inserted] AS [i];

		OPEN productionLine_cursor;

		FETCH NEXT FROM productionLine_cursor
		INTO @id, @productionLine;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO [Log] ([productionLineId], [log]) VALUES (@id, 'INSERT ProductionLine id ' + CAST(@id AS nvarchar(MAX)) + ' -> ' + @productionLine);
			FETCH NEXT FROM productionLine_cursor
			INTO @id, @productionLine;
		END	
		
		CLOSE productionLine_cursor;
		DEALLOCATE productionLine_cursor;
    END
GO

CREATE TRIGGER [dbo].[Trigger_ProductionLineAfterUpdate]
    ON [dbo].[ProductionLine]
    AFTER UPDATE
    AS
    BEGIN
        SET NoCount ON;
		
		DECLARE @log nvarchar(MAX), @id int, @productionLine_d char(4), @productionLine_i char(4);

		DECLARE productionLine_cursor CURSOR FOR
		SELECT [d].[id], [d].[productionLine], [i].[productionLine]
		FROM [inserted] AS [i]
		INNER JOIN [deleted] AS [d]
		ON [i].[id] = [d].[id];

		OPEN productionLine_cursor;

		FETCH NEXT FROM productionLine_cursor
		INTO @id, @productionLine_d, @productionLine_i;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO [Log] ([productionLineId], [log]) VALUES (@id, 'UPDATE ProductionLine id ' + CAST(@id AS nvarchar(MAX)) + ' ; OLD VALUES: ' + @productionLine_d + ' ; NEW VALUES: ' + @productionLine_i);
			FETCH NEXT FROM productionLine_cursor
			INTO @id, @productionLine_d, @productionLine_i;
		END	
		
		CLOSE productionLine_cursor;
		DEALLOCATE productionLine_cursor;
	END
GO

CREATE TRIGGER [dbo].[Trigger_ProductionLineAfterDelete]
    ON [dbo].[ProductionLine]
    AFTER DELETE
    AS
    BEGIN
        SET NoCount ON;
		
		DECLARE @log nvarchar(MAX), @id int, @productionLine char(4);

		DECLARE productionLine_cursor CURSOR FOR SELECT [d].[id], [d].[productionLine] FROM [deleted] AS [d];

		OPEN productionLine_cursor;

		FETCH NEXT FROM productionLine_cursor
		INTO @id, @productionLine;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO [Log] ([productionLineId], [log]) VALUES (@id, 'DELETE ProductionLine id ' + CAST(@id AS nvarchar(MAX)) + ' -> ' + @productionLine);
			FETCH NEXT FROM productionLine_cursor
			INTO @id, @productionLine;
		END	
		
		CLOSE productionLine_cursor;
		DEALLOCATE productionLine_cursor;
    END