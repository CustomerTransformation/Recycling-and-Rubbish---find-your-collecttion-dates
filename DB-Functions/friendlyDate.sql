USE [FStepMapInfo_prod]
GO
/****** Object:  UserDefinedFunction [dbo].[friendlyDate]    Script Date: 30/03/2020 19:41:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Daniel Gregory
-- Create date: 30/03/2020
-- Description:	return date starting with day name follwoed by day of month, month name and year.
-- =============================================
ALTER FUNCTION [dbo].[friendlyDate]
(
	@forDate as date
)
RETURNS varchar(50)
AS
BEGIN
	DECLARE @FriendlyDate VARCHAR(50)
					
	SET @FriendlyDate = DATENAME(dw,@forDate) + ' ' + DATENAME(d,@forDate) + ' ' + DATENAME(m,@forDate) + ' ' + DATENAME(yy,@forDate);

	-- Return the result of the function
	RETURN @FriendlyDate

END
