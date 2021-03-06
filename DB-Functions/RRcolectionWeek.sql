USE [FStepMapInfo_prod]
GO
/****** Object:  UserDefinedFunction [dbo].[RRcolectionWeek]    Script Date: 30/03/2020 19:41:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Daniel Gregory
-- Create date: 30/03/2020
-- Description:	Get the Recycling and Rubbish collection week for a date
-- =============================================
ALTER FUNCTION [dbo].[RRcolectionWeek]
(
	@forDate as date
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @noWeeks as int
			,@lastDig as varchar(1)
			,@curWk as int

	SET @noWeeks = DATEDIFF(week, '2020/01/06', DATEADD(day, -1, @forDate))
	SET @lastDig = RIGHT(@noWeeks, 1)
	IF CHARINDEX(@lastDig, '1,3,5,7,9') > 0
		SET @curWk = 2
	ELSE
		SET @curWk = 1

	-- Return the result of the function
	RETURN @curWk

END
