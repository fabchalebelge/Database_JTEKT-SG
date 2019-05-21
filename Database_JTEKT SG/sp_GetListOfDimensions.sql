CREATE PROCEDURE [dbo].[sp_GetListOfDimensions]
	@productionLineId int
AS
	SELECT [id] FROM [Dimension] WHERE [partNumberId] = (SELECT [partNumberId] FROM [ExchangeTable] WHERE [productionLineId] = @productionLineId);
RETURN 0
