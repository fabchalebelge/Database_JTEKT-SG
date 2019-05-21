CREATE PROCEDURE [dbo].[sp_SetMeasurement]
	@productionLineId int,
	@measuredPartId bigint,
	@dimensionId int,
	@value decimal(7,4)
AS
	DECLARE @valid bit;
	INSERT INTO [Measurement] ([measuredPartId], [dimensionId], [value]) VALUES (@measuredPartId, @dimensionId, CAST(@value AS decimal(7,4)));
	SET @valid = (SELECT [valid] FROM [Measurement] WHERE [id] = @@IDENTITY);

	UPDATE [ExchangeTable]
	SET [measurementValid] = @valid
	WHERE [productionLineId] = @productionLineId;
RETURN 0
