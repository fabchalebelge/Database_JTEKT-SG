CREATE PROCEDURE [dbo].[sp_GetMeasuredPartId]
	@productionLineId int,
	@workOrderId int
AS
	DECLARE @measuredPartId bigint;
	INSERT INTO [MeasuredPart] ([workOrderId]) VALUES (@workOrderId);
	SET @measuredPartId = @@IDENTITY;

	UPDATE [ExchangeTable]
	SET 
		[measuredPartId] = @measuredPartId,
		[measurementValid] = NULL
	WHERE [productionLineId] = @productionLineId;
RETURN 0
