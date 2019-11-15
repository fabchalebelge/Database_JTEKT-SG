
DECLARE @myWorkOrderId int;
SET @myWorkOrderId = (SELECT [workOrderId] FROM [ExchangeTable] WHERE [productionLineId]=2)
EXECUTE sp_GetMeasuredPartId @productionLineId=2, @workOrderId=@myWorkOrderId;

DECLARE @myMeasurement decimal(7,4), @myMeasuredPartId bigint, @myDimensionId int;
SET @myMeasurement = (SELECT 7.95 + RAND() * (8.03-7.95));
--SET @myMeasurement = (SELECT 7.965 + RAND() * (8.015-7.965));
--SET @myMeasurement = 99;
SET @myMeasuredPartId = (SELECT [measuredPartId] FROM [ExchangeTable] WHERE [productionLineId] = 2);
SET @myDimensionId = (SELECT [id] FROM [Dimension] WHERE [partNumberId] = (SELECT [partNumberId] FROM [ExchangeTable] WHERE [productionLineId] = 2));
EXECUTE sp_SetMeasurement @productionLineId=2, @measuredPartId=@myMeasuredPartId, @dimensionId=@myDimensionId, @value=@myMeasurement;

DECLARE @myValid bit;
SET @myValid = (SELECT [measurementValid] FROM [ExchangeTable] WHERE [productionLineId] = 2);
EXECUTE sp_SetPartStatus @measuredPartId=@myMeasuredPartId, @valid=@myValid;