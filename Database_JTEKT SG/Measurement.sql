CREATE TABLE [dbo].[Measurement]
(
	[id] BIGINT NOT NULL PRIMARY KEY IDENTITY, 
    [dimensionId] INT NULL, 
    [measuredPartId] BIGINT NULL, 
    [timeStamp] DATETIME NULL DEFAULT GetDate(), 
    [value] DECIMAL(7, 4) NULL, 
    [valid] BIT NULL, 
    [min] DECIMAL(6, 3) NULL, 
    [max] DECIMAL(6, 3) NULL, 
    CONSTRAINT [FK_Measurement_dimensionId] FOREIGN KEY ([dimensionId]) REFERENCES [Dimension]([id]), 
    CONSTRAINT [FK_Measurement_measuredPartId] FOREIGN KEY ([measuredPartId]) REFERENCES [MeasuredPart]([id]) 
)

GO


CREATE TRIGGER [dbo].[Trigger_MeasurementAfterInsert]
    ON [dbo].[Measurement]
    AFTER INSERT
    AS
    BEGIN
        SET NoCount ON;
		SET xact_abort OFF;
		DECLARE
			@value decimal(7,4) = (SELECT [value] FROM [inserted]),
			@min decimal(6,3) = (SELECT [nominal] + [lowerTolerance] FROM [Dimension] WHERE [id] = (SELECT [dimensionId] FROM [inserted])),
			@max decimal(6,3) = (SELECT [nominal] + [higherTolerance] FROM [Dimension] WHERE [id] = (SELECT [dimensionId] FROM [inserted])),
			@valid bit,
			@MyString varchar(max),
			@MyPath varchar(255),
			@MyFilename varchar(100),
			@MyWorkOrderId int,
			@MyWorkOrder varchar(50),
			@MyTimeStamp datetime = (SELECT [timeStamp] FROM [inserted]);

		IF @value >= @min AND @value <= @max
			SET @valid = 1
		ELSE
			SET @valid = 0;

		UPDATE [Measurement] SET
			[valid] = @valid,
			[min] = @min,
			[max] = @max
		FROM [inserted]
		WHERE [Measurement].[id] = [inserted].[id];
/*
		SET @MyWorkOrderId = (SELECT [workOrderId]
								FROM [MeasuredPart]
								INNER JOIN [inserted] ON [inserted].[measuredPartId] = [MeasuredPart].[id]);

		IF @MyWorkOrderId IS NULL
			SET @MyWorkOrder = 'Indéfini';
		ELSE
			SET @MyWorkOrder = (SELECT [workOrder] FROM [WorkOrder] WHERE [id] = @MyWorkOrderId);

		SET @MyPath = (SELECT [value] FROM [Config] WHERE [id] = 1);
		SET @MyPath = @MyPath + '\' + (SELECT [productionLine]
										FROM [ProductionLine]
										INNER JOIN [PartNumber] ON [PartNumber].[productionLineId] = [ProductionLine].[id]
										INNER JOIN [MeasuredPart] ON [MeasuredPart].[partNumberId] = [PartNumber].[id]
										INNER JOIN [inserted] ON [inserted].[measuredPartId] = [MeasuredPart].[id]);

		SET @MyFilename = (SELECT [partNumber]
							FROM [PartNumber]
							INNER JOIN [MeasuredPart] ON [MeasuredPart].[partNumberId] = [PartNumber].[id]
							INNER JOIN [inserted] ON [inserted].[measuredPartId] = [MeasuredPart].[id]);
		SET @MyFilename = @MyFilename +  '_' + (SELECT [dimension]
												FROM [Dimension]
												INNER JOIN [inserted] ON [inserted].[dimensionId] = [Dimension].[id]);
		SET @MyFilename = @MyFilename + '_' + replace(replace(convert(varchar, @MyTimeStamp, 20),' ','_'),':','-');
		SET @MyFilename = @MyFilename + '.csv';

		SET @MyString = 'Nom de gamme,';
		SET @MyString = @MyString + (SELECT [productionLine]
										FROM [ProductionLine]
										INNER JOIN [PartNumber] ON [PartNumber].[productionLineId] = [ProductionLine].[id]
										INNER JOIN [MeasuredPart] ON [MeasuredPart].[partNumberId] = [PartNumber].[id]
										INNER JOIN [inserted] ON [inserted].[measuredPartId] = [MeasuredPart].[id]);
		SET @MyString = @MyString + CHAR(13) + CHAR(10) + 'Nom de pièce,';
		SET @MyString = @MyString + (SELECT [partNumber]
										FROM [PartNumber]
										INNER JOIN [MeasuredPart] ON [MeasuredPart].[partNumberId] = [PartNumber].[id]
										INNER JOIN [inserted] ON [inserted].[measuredPartId] = [MeasuredPart].[id]);
		SET @MyString = @MyString + CHAR(13) + CHAR(10) + 'Nom de collecte,';
		SET @MyString = @MyString + @MyWorkOrder;
		SET @MyString = @MyString + CHAR(13) + CHAR(10) + 'Caractéristique,';
		SET @MyString = @MyString + (SELECT [dimension]
										FROM [Dimension]
										INNER JOIN [inserted] ON [inserted].[dimensionId] = [Dimension].[id]);
		SET @MyString = @MyString + CHAR(13) + CHAR(10) + 'TimeStamp,';
		SET @MyString = @MyString + convert(varchar, @MyTimeStamp, 20);
		SET @MyString = @MyString + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'Min,Valeur,Max';
		SET @MyString = @MyString + CHAR(13) + CHAR(10) + CAST((SELECT [Measurement].[min] FROM [Measurement] INNER JOIN [inserted] ON [Measurement].[id] = [inserted].[id]) AS varchar(max)) + ',';
		SET @MyString = @MyString + CAST((SELECT [Measurement].[value] FROM [Measurement] INNER JOIN [inserted] ON [Measurement].[id] = [inserted].[id]) AS varchar(max)) + ',';
		SET @MyString = @MyString + CAST((SELECT [Measurement].[max] FROM [Measurement] INNER JOIN [inserted] ON [Measurement].[id] = [inserted].[id]) AS varchar(max));

		BEGIN TRY
			EXEC sp_WriteStringToFile @String=@MyString, @Path=@MyPath, @Filename=@MyFilename;
		END TRY
		BEGIN CATCH

		END CATCH
*/
    END