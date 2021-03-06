USE [FStepMapInfo_prod]
GO
/****** Object:  UserDefinedFunction [dbo].[friendlyDay]    Script Date: 30/03/2020 19:41:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Daniel Gregory
-- Create date: 30/03/2020
-- Description:	return reference to day using yesterday, today, tommorow, on Monday etc.
-- =============================================
ALTER FUNCTION [dbo].[friendlyDay]
(
	@forDate as date
)
RETURNS varchar(50)
AS
BEGIN
	DECLARE @friendlyDay as varchar(50)
			,@DiffToToday as int
			,@weekDiff as int
	
	SET @DiffToToday = DATEDIFF(day, GETDATE(), @forDate)
	SET @weekDiff = DATEDIFF(week, '2020/01/06', DATEADD(day, -1, @forDate)) - DATEDIFF(week, '2020/01/06', DATEADD(day, -1, GETDATE()))

	SET @FriendlyDay = CASE
							WHEN @DiffToToday = -1
								THEN 'yesterday'
							
							WHEN @DiffToToday = 0
								THEN 'today'
							
							WHEN @DiffToToday = 1
								THEN 'tomorrow'
							
							WHEN @weekDiff = 0
								THEN ('on ' + DATENAME(dw,@forDate))
							
							WHEN @weekDiff = -1
								THEN ('on ' + DATENAME(dw,@forDate) + ' last week')
							
							WHEN @weekDiff = -2
								THEN ('on ' + DATENAME(dw,@forDate) + ' two weeks ago')
							
							WHEN @weekDiff = -3
								THEN ('on ' + DATENAME(dw,@forDate) + ' three weeks ago')
							
							WHEN @weekDiff = 1
								THEN ('on ' + DATENAME(dw,@forDate) + ' next week')
							
							WHEN @weekDiff = 2
								THEN ('on ' + DATENAME(dw,@forDate) + ' week after next')
							
							WHEN @weekDiff = 3
								THEN ('on ' + DATENAME(dw,@forDate) + ' in three weeks')
							ELSE 'Error DiffToToday' + CAST(isnull(@DiffToToday,'NULL') as varchar(10)) + '  weekDiff ' + CAST(isnull(@weekDiff,'NULL') as varchar(10))
						END

	IF @DiffToToday < 0
	BEGIN
		SET @FriendlyDay = 'was ' + @FriendlyDay;
	END
	IF @DiffToToday > -1
	BEGIN
		SET @FriendlyDay = 'is ' + @FriendlyDay;
	END

	--SET @FriendlyDay =  @FriendlyDay + ' ' + CAST(@weekDiff as varchar(10))

	-- Return the result of the function, note taking Monday as first day of the week
	RETURN @FriendlyDay

END
