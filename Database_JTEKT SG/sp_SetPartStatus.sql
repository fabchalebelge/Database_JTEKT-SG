CREATE PROCEDURE [dbo].[sp_SetPartStatus]
	@measuredPartId bigint,
	@valid bit
AS
	UPDATE [MeasuredPart] SET [valid] = @valid WHERE [id] = @measuredPartId;
RETURN 0
