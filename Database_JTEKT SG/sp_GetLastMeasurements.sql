CREATE PROCEDURE [dbo].[sp_GetLastMeasurements]
	@n int,
	@dimensionId int
AS
	SELECT *
	FROM (SELECT TOP (@n) [id], [value], [min], [max] FROM [Measurement] WHERE [dimensionId] = @dimensionId ORDER BY [id] DESC) AS [TempTable]
	ORDER BY [id];
RETURN 0
