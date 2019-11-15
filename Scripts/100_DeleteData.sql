DELETE FROM [Measurement];
DELETE FROM [MeasuredPart];
DELETE FROM [WorkOrder];

UPDATE [ExchangeTable]
SET
	[workOrderId] = NULL,
	[workOrder] = NULL,
	[partNumberId] = NULL,
	[partNumber] = NULL,
	[measuredPartId] = NULL,
	[measurementValid] = NULL
WHERE [productionLineId] = 2;