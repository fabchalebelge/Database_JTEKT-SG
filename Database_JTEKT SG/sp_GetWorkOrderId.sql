CREATE PROCEDURE [dbo].[sp_GetWorkOrderId]
	@productionLineId int,
	@partNumber nvarchar(16),
	@workOrder nchar(6)
AS

	DECLARE @partNumberId int, @workOrderId int;

	SELECT @workOrderId = [id], @partNumberId = [partNumberId] FROM [WorkOrder] WHERE [workOrder] = @workOrder;

	IF @workOrderId IS NULL
		BEGIN
			SET @partNumberId = (SELECT [id] FROM [PartNumber] WHERE [productionLineId] = @productionLineId AND [partNumber] LIKE '%' + @partNumber);
			IF @partNumberId IS NULL
				RETURN 100 --Part Number inexistant pour cette ligne de production
			ELSE
				BEGIN
					INSERT INTO [WorkOrder] ([partNumberId], [workOrder]) VALUES (@partNumberId, @workOrder);
					SET @workOrderId = @@IDENTITY;
				END
		END
	ELSE
		BEGIN --Attention, les erreurs générées ci-dessous n'empêchent pas actuellement d'envoyer le workOrderId !!!
			IF @partNumberId IS NULL
				RETURN 101 --OF existe mais n'est lié à aucun Part Number
			IF @productionLineId != (SELECT [productionLineId] FROM [PartNumber] WHERE [id] = @partNumberId)
				RETURN 102 --OF existe mais a été créé sur une autre ligne de production
			IF @partNumberId != (SELECT [id] FROM [PartNumber] WHERE [productionLineId] = @productionLineId AND [partNumber] LIKE '%' + @partNumber)
				RETURN 103 --OF existe mais n'est pas lié au bon Part Number
		END

	UPDATE [ExchangeTable]
	SET 
		[workOrderId] = @workOrderId,
		[workOrder] = @workOrder,
		[partNumberId] = @partNumberId,
		[partNumber] = (SELECT [partNumber] FROM [PartNumber] WHERE [id] = @partNumberId),
		[workOrderSize] = NULL,
		[measuredPartId] = NULL,
		[measurementValid] = NULL
	WHERE [productionLineId] = @productionLineId;

RETURN 0
