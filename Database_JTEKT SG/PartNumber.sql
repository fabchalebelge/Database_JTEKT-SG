CREATE TABLE [dbo].[PartNumber]
(
	[id] INT NOT NULL PRIMARY KEY, 
    [productionLineId] INT NULL, 
    [partNumber] NCHAR(16) NULL, 
    CONSTRAINT [FK_PartNumber_productionLineId] FOREIGN KEY ([productionLineId]) REFERENCES [ProductionLine]([id])
)

GO

CREATE INDEX [IX_PartNumber_partNumber] ON [dbo].[PartNumber] ([partNumber])

GO

CREATE TRIGGER [dbo].[Trigger_PartNumberAfterInsert]
    ON [dbo].[PartNumber]
    AFTER INSERT
    AS
    BEGIN
        SET NoCount ON;
		
		DECLARE @log nvarchar(MAX), @id int, @productionLineId int, @partNumber nvarchar(MAX);

		DECLARE partNumber_cursor CURSOR FOR SELECT [i].[id], [i].[productionLineId], [i].[partNumber] FROM [inserted] AS [i];

		OPEN partNumber_cursor;

		FETCH NEXT FROM partNumber_cursor
		INTO @id, @productionLineId, @partNumber;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @log = 'INSERT PartNumber id ' + CAST(@id AS nvarchar(MAX)) + ' -> ' + @partNumber;
			INSERT INTO [Log] ([productionLineId], [partNumberId], [log]) VALUES (@productionLineId, @Id, @log);
			FETCH NEXT FROM partNumber_cursor
			INTO @id, @productionLineId, @partNumber;
		END	
	
		CLOSE partNumber_cursor;
		DEALLOCATE partNumber_cursor;
	END
GO

CREATE TRIGGER [dbo].[Trigger_PartNumberAfterUpdate]
    ON [dbo].[PartNumber]
    AFTER UPDATE
    AS
    BEGIN
        SET NoCount ON;
		
		DECLARE @log nvarchar(MAX), @id int, @productionLineId int, @partNumber_d nvarchar(MAX), @partNumber_i nvarchar(MAX);

		DECLARE partNumber_cursor CURSOR FOR
		SELECT [d].[id], [d].[productionLineId], [d].[partNumber], [i].[partNumber]
		FROM [inserted] AS [i]
		INNER JOIN [deleted] AS [d]
		ON [i].[id] = [d].[id];

		OPEN partNumber_cursor;

		FETCH NEXT FROM partNumber_cursor
		INTO @id, @productionLineId, @partNumber_d, @partNumber_i;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @log = 'UPDATE PartNumber id ' + CAST(@id AS nvarchar(MAX));
			SET @log = @log + ' ; OLD VALUES: ' + @partNumber_d;
			SET @log = @log + ' ; NEW VALUES: ' + @partNumber_i;
			INSERT INTO [Log] ([productionLineId], [partNumberId], [log]) VALUES (@productionLineId, @Id, @log);
			FETCH NEXT FROM partNumber_cursor
			INTO @id, @productionLineId, @partNumber_d, @partNumber_i;
		END	
		
		CLOSE partNumber_cursor;
		DEALLOCATE partNumber_cursor;
	END
GO

CREATE TRIGGER [dbo].[Trigger_PartNumberAfterDelete]
    ON [dbo].[PartNumber]
    AFTER DELETE
    AS
    BEGIN
        SET NoCount ON;
		
		DECLARE @log nvarchar(MAX), @id int, @productionLineId int, @partNumber nvarchar(MAX);

		DECLARE partNumber_cursor CURSOR FOR SELECT [d].[id], [d].[productionLineId], [d].[partNumber] FROM [deleted] AS [d];

		OPEN partNumber_cursor;

		FETCH NEXT FROM partNumber_cursor
		INTO @id, @productionLineId, @partNumber;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @log = 'DELETE PartNumber id ' + CAST(@id AS nvarchar(MAX)) + ' -> ' + @partNumber;
			INSERT INTO [Log] ([productionLineId], [partNumberId], [log]) VALUES (@productionLineId, @Id, @log);
			FETCH NEXT FROM partNumber_cursor
			INTO @id, @productionLineId, @partNumber;
		END	
		
		CLOSE partNumber_cursor;
		DEALLOCATE partNumber_cursor;
	END