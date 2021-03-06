USE [FStepMapInfo_prod]
GO
/****** Object:  UserDefinedFunction [dbo].[listToFullDayNames]    Script Date: 30/03/2020 19:41:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Daniel Gregory
-- Create date: 30/03/2020
-- Description:	turn list of abreviated days in to list with day names in full for comparison to day of week function values
-- =============================================
ALTER FUNCTION [dbo].[listToFullDayNames]
(
	@daysList as varchar(100)
)
RETURNS  varchar(60)
AS
BEGIN
	DECLARE @daysOut varchar(60) = ''

	IF CHARINDEX('Mo', @daysList) > 0
		SET @daysOut = 'Monday,'

	IF CHARINDEX('Tu', @daysList) > 0
		SET @daysOut = @daysOut + 'Tuesday,'

	IF CHARINDEX('We', @daysList) > 0
		SET @daysOut = @daysOut + 'Wednesday,'

	IF CHARINDEX('Th', @daysList) > 0
		SET @daysOut = @daysOut + 'Thursday,'

	IF CHARINDEX('Fr', @daysList) > 0
		SET @daysOut = @daysOut + 'Friday,'

	IF CHARINDEX('Sa', @daysList) > 0
		SET @daysOut = @daysOut + 'Saturday,'

	IF CHARINDEX('Su', @daysList) > 0
		SET @daysOut = @daysOut + 'Sunday,'

	IF LEN(@daysOut) > 3
		SET @daysOut = LEFT(@daysOut, LEN(@daysOut) - 1)

	-- Return the result of the function
	RETURN @daysOut

END
