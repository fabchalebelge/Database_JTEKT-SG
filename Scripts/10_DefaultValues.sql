USE [side_gear];

DELETE FROM [Measurement];
DELETE FROM [MeasuredPart];
DELETE FROM [Dimension];
DELETE FROM [PartNumber];
DELETE FROM [ProductionLine];
DELETE FROM [Config];
DELETE FROM [ExchangeTable];

INSERT INTO [Config] ([id], [parameter], [value]) VALUES
	(1, 'Path to CSV MeasureLink', '\\SERV14\Exchange_SQL');

INSERT INTO [ProductionLine] ([id], [productionLine]) VALUES
	(1, 'SG03'),
	(2, 'SG05'),
	(3, 'SG07');

INSERT INTO [ExchangeTable] ([productionLineId]) VALUES
	(1), (2), (3);

INSERT INTO [PartNumber] ([id],	[productionLineId], [partNumber]) VALUES
	--SG07
	(1, 3, 'EA49 490020-3200'),
	(2, 3, 'EY05 490052-2200'),
	(3, 3, 'EY05 490052-2300'),
	(4, 3, 'EY06 490052-2400'),
	(5, 3, 'EY06 490052-2500'),
	(6, 3, 'UE24 490052-1400'),
	(7, 3, 'UE24 490052-1500'),
	--SG05
	(8, 2, 'UE24 490023-3400'),
	(9, 2, 'UE24 490023-3500'),
	(10, 2, 'UE22 490052-0600'),
	(11, 2, 'UE22 490052-0700'),
	(12, 2, 'DZ01 490020-3600');

INSERT INTO [Dimension] ([id], [partNumberId], [dimension], [nominal], [higherTolerance], [lowerTolerance], [unit]) VALUES
	--SG07
	(1, 1, 'Hauteur', 31.950, 0.025, -0.025, 'mm'),
	(2, 2, 'Hauteur', 28.930, 0.020, -0.020, 'mm'),
	(3, 3, 'Hauteur', 28.930, 0.020, -0.020, 'mm'),
	(4, 4, 'Hauteur', 37.480, 0.025, -0.025, 'mm'),
	(5, 5, 'Hauteur', 34.480, 0.025, -0.025, 'mm'),
	(6, 6, 'Hauteur', 40.895, 0.013, -0.013, 'mm'),
	(7, 7, 'Hauteur', 40.895, 0.013, -0.013, 'mm'),
	--SG05
	(8, 8, 'Hauteur', 7.990, 0.025, -0.025, 'mm'),
	(9, 9, 'Hauteur', 7.990, 0.025, -0.025, 'mm'),
	(10, 10, 'Hauteur', 33.835, 0.015, -0.015, 'mm'),
	(11, 11, 'Hauteur', 33.835, 0.015, -0.015, 'mm'),
	(12, 12, 'Hauteur', 30.200, 0.025, -0.025, 'mm');