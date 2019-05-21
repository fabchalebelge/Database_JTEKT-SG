CREATE PROCEDURE [dbo].[sp_GetPartNumbers]
	@productionLineId int
AS
	BEGIN
		SELECT partNumber
		FROM PartNumber
		WHERE productionLineId = @productionLineId
	END
