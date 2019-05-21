CREATE TABLE [dbo].[WorkOrder]
(
	[id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [partNumberId] INT NULL, 
    [workOrder] NCHAR(6) NULL, 
    [timeStampStart] DATETIME NULL DEFAULT GetDate(), 
    [timeStampStop] DATETIME NULL, 
    [numOfPieces] SMALLINT NULL, 
    [numOfPiecesOk] SMALLINT NULL, 
    [numOfPiecesNok] SMALLINT NULL, 
    [size] SMALLINT NULL
)
