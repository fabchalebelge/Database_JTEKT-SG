CREATE TABLE [dbo].[Dimension]
(
	[id] INT NOT NULL PRIMARY KEY, 
    [partNumberId] INT NULL, 
    [dimension] nvarchar(100) NULL, 
    [nominal] NUMERIC(6, 3) NULL, 
    [higherTolerance] NUMERIC(6, 3) NULL, 
    [lowerTolerance] NUMERIC(6, 3) NULL, 
    [unit] NVARCHAR(10) NULL, 
    CONSTRAINT [FK_Dimension_partNumberId] FOREIGN KEY ([partNumberId]) REFERENCES [PartNumber]([id])
)

GO

CREATE TRIGGER [dbo].[Trigger_DimensionAfterUpdate]
    ON [dbo].[Dimension]
    AFTER UPDATE
    AS
    BEGIN
        SET NoCount ON;
		
		DECLARE @log nvarchar(MAX), @id int, @productionLineId int, @partNumberId int,
			@dimension_d nvarchar(100), @nominal_d numeric(6,3), @higherTolerance_d numeric(6,3), @lowerTolerance_d numeric(6,3), @unit_d nvarchar(10),
			@dimension_i nvarchar(100),	@nominal_i numeric(6,3), @higherTolerance_i numeric(6,3), @lowerTolerance_i numeric(6,3), @unit_i nvarchar(10);

		DECLARE dimension_cursor CURSOR FOR
		SELECT [d].[id], [pn].[productionLineId], [d].[partNumberId],
			[d].[dimension], [d].[nominal], [d].[higherTolerance], [d].[lowerTolerance], [d].[unit],
			[i].[dimension], [i].[nominal], [i].[higherTolerance], [i].[lowerTolerance], [i].[unit]
		FROM [inserted] AS [i]
		INNER JOIN [deleted] AS [d]
		ON [i].[id] = [d].[id]
		INNER JOIN [PartNumber] AS [pn]
		ON [pn].[id] = [i].[partNumberId];

		OPEN dimension_cursor;

		FETCH NEXT FROM dimension_cursor
		INTO @id, @productionLineId, @partNumberId,
			@dimension_d, @nominal_d, @higherTolerance_d, @lowerTolerance_d, @unit_d,
			@dimension_i, @nominal_i, @higherTolerance_i, @lowerTolerance_i, @unit_i;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @log = 'UPDATE Dimension id ' + CAST(@id AS nvarchar(MAX));
			SET @log = @log + ' ; OLD VALUES: ' + @dimension_d + ' = ' + CAST(@nominal_d AS nvarchar(MAX)) + ' ' + CAST(@higherTolerance_d AS nvarchar(MAX)) + ' / ' + CAST(@lowerTolerance_d AS nvarchar(MAX)) + ' ' + @unit_d;
			SET @log = @log + ' ; NEW VALUES: ' + @dimension_i + ' = ' + CAST(@nominal_i AS nvarchar(MAX)) + ' ' + CAST(@higherTolerance_i AS nvarchar(MAX)) + ' / ' + CAST(@lowerTolerance_i AS nvarchar(MAX)) + ' ' + @unit_i;
			INSERT INTO [Log] ([productionLineId], [partNumberId], [dimensionId], [log]) VALUES (@productionLineId, @partNumberId, @id, @log);
			FETCH NEXT FROM dimension_cursor
			INTO @id, @productionLineId, @partNumberId,
				@dimension_d, @nominal_d, @higherTolerance_d, @lowerTolerance_d, @unit_d,
				@dimension_i, @nominal_i, @higherTolerance_i, @lowerTolerance_i, @unit_i;
		END	
		
		CLOSE dimension_cursor;
		DEALLOCATE dimension_cursor;
    END
GO

CREATE TRIGGER [dbo].[Trigger_DimensionAfterInsert]
    ON [dbo].[Dimension]
    AFTER INSERT
    AS
    BEGIN
        SET NoCount ON;
		
		DECLARE @log nvarchar(MAX), @id int, @productionLineId int, @partNumberId int,
			@dimension nvarchar(100),	@nominal numeric(6,3), @higherTolerance numeric(6,3), @lowerTolerance numeric(6,3), @unit nvarchar(10);

		DECLARE dimension_cursor CURSOR FOR
		SELECT [i].[id], [pn].[productionLineId], [i].[partNumberId],
			[i].[dimension], [i].[nominal], [i].[higherTolerance], [i].[lowerTolerance], [i].[unit]
		FROM [inserted] AS [i]
		INNER JOIN [PartNumber] AS [pn]
		ON [pn].[id] = [i].[partNumberId];

		OPEN dimension_cursor;

		FETCH NEXT FROM dimension_cursor
		INTO @id, @productionLineId, @partNumberId,
			@dimension, @nominal, @higherTolerance, @lowerTolerance, @unit;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @log = 'INSERT Dimension id ' + CAST(@id AS nvarchar(MAX));
			SET @log = @log + ' -> ' + @dimension + ' = ' + CAST(@nominal AS nvarchar(MAX)) + '  ' + CAST(@higherTolerance AS nvarchar(MAX)) + ' / ' + CAST(@lowerTolerance AS nvarchar(MAX)) + ' ' + @unit;
			INSERT INTO [Log] ([productionLineId], [partNumberId], [dimensionId], [log]) VALUES (@productionLineId, @partNumberId, @id, @log);
			FETCH NEXT FROM dimension_cursor
			INTO @id, @productionLineId, @partNumberId,
				@dimension, @nominal, @higherTolerance, @lowerTolerance, @unit;
		END	
		
		CLOSE dimension_cursor;
		DEALLOCATE dimension_cursor;
    END
GO

CREATE TRIGGER [dbo].[Trigger_DimensionAfterDelete]
    ON [dbo].[Dimension]
    AFTER DELETE
    AS
    BEGIN
        SET NoCount ON;
		
		DECLARE @log nvarchar(MAX), @id int, @productionLineId int, @partNumberId int,
			@dimension nvarchar(100),	@nominal numeric(6,3), @higherTolerance numeric(6,3), @lowerTolerance numeric(6,3), @unit nvarchar(10);

		DECLARE dimension_cursor CURSOR FOR
		SELECT [d].[id], [pn].[productionLineId], [d].[partNumberId],
			[d].[dimension], [d].[nominal], [d].[higherTolerance], [d].[lowerTolerance], [d].[unit]
		FROM [deleted] AS [d]
		INNER JOIN [PartNumber] AS [pn]
		ON [pn].[id] = [d].[partNumberId];

		OPEN dimension_cursor;

		FETCH NEXT FROM dimension_cursor
		INTO @id, @productionLineId, @partNumberId,
			@dimension, @nominal, @higherTolerance, @lowerTolerance, @unit;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @log = 'DELETE Dimension id ' + CAST(@id AS nvarchar(MAX));
			SET @log = @log + ' -> ' + @dimension + ' = ' + CAST(@nominal AS nvarchar(MAX)) + '  ' + CAST(@higherTolerance AS nvarchar(MAX)) + ' / ' + CAST(@lowerTolerance AS nvarchar(MAX)) + ' ' + @unit;
			INSERT INTO [Log] ([productionLineId], [partNumberId], [dimensionId], [log]) VALUES (@productionLineId, @partNumberId, @id, @log);
			FETCH NEXT FROM dimension_cursor
			INTO @id, @productionLineId, @partNumberId,
				@dimension, @nominal, @higherTolerance, @lowerTolerance, @unit;
		END	
		
		CLOSE dimension_cursor;
		DEALLOCATE dimension_cursor;
    END