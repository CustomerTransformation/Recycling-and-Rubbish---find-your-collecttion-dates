USE [FStepMapInfo_prod]
GO
/****** Object:  StoredProcedure [dbo].[RecRubNextCollectionDatesForUPRN]    Script Date: 30/03/2020 19:40:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Daniel Gregory
-- Create date: 30/03/2020
-- Description:	Return summary of next collection for address as well as lists of next 10 for Rubbish and Recycling
-- =============================================
ALTER PROCEDURE [dbo].[RecRubNextCollectionDatesForUPRN] 
	@UPRN as int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @queryStr as varchar(550)
			,@uprn_out as int
			,@daysRef as varchar(550)
			,@refType as varchar(550)
			,@refRound as varchar(550)
			,@noRef as int
			,@daysRec as varchar(550)
			,@recType as varchar(550)
			,@recRound as varchar(550)
			,@recWeek as int
			,@noRec as int
			,@wrkDate as date
			,@colWeek as int
			,@endDate as date
			,@currDay as varchar(15)
	
	DECLARE @Temp table (
					[UPRN] int
					,[Fulladd] varchar(550)
					,[number] varchar(550)
					,[Street] varchar(550)
					,[Post_Town] varchar(550)
					,[Postcode] varchar(550)
					,[USRN] varchar(550)
					,[BLPU_CLASS] varchar(550)
					,[Refuse_type] varchar(550)
					,[Ref_ID] varchar(550)
					,[Ref_Day] varchar(550)
					,[Ref_Round] varchar(550)
					,[Recycling_type] varchar(550)
					,[Rec_ID] varchar(550)
					,[Rec_Day] varchar(550)
					,[Rec_Week] varchar(550)
					,[Rec_Round] varchar(550))
					
					
--add to one variable days of week for Rub and to Rec and other info on collections into variables				
		
	SET @queryStr = 'SELECT *
	FROM openquery([PCC.DYNAMICMAPS.CO.UK],
	''SELECT TOP 1 [UPRN]
		  ,[Fulladd]
		  ,[number]
		  ,[Street]
		  ,[Post_Town]
		  ,[Postcode]
		  ,[USRN]
		  ,[BLPU_CLASS]
		  ,[Refuse_type]
		  ,[Ref_ID]
		  ,[Ref_Day]
		  ,[Ref_Round]
		  ,[Recycling_type]
		  ,[Rec_ID]
		  ,[Rec_Day]
		  ,[Rec_Week]
		  ,[Rec_Round]
	  FROM [GeoStorePCC].[dbo].[waste_collection_addr]
	  WHERE [UPRN] = ' + CAST(@UPRN as varchar(20)) + ''')'

	INSERT INTO @Temp
	EXEC(@querystr)


	SELECT @uprn_out = UPRN
			,@daysRef = [Ref_Day]
			,@refType = [Refuse_type]
			,@refRound = [Ref_Round]
			,@daysRec = [Rec_Day]
			,@recType = [Recycling_type]
			,@recRound = [Rec_Round]
			,@recWeek = [Rec_Week]
	FROM @Temp

	IF ISNULL(@uprn_out, '') != @UPRN
	BEGIN
		SELECT  'no results' as intRun2
		RETURN
	END

	SET @daysRef = dbo.listToFullDayNames(@daysRef)

	SET @noRef = LEN(@daysRef)
	
	IF @noRef > 3
		SET @noRef = 1 + (@noRef - LEN(REPLACE(@daysRef, ',', '')))

	SET @daysRec = dbo.listToFullDayNames(@daysRec)

	SET @noRec = LEN(@daysRec)
	
	IF @noRec > 3
		SET @noRec = 1 + (@noRec - LEN(REPLACE(@daysRec, ',', '')))

	DECLARE @TempDates table (colDate	date NOT NULL,
							  DayOfCol	varchar(50) NOT NULL,
							  DateOfCol	varchar(100) NOT NULL,
							  TypeOfCol	varchar(20) NOT NULL,
							  isExcep		int NULL);

--if day of week is sunday change curr week to other as gone back to previous week SCRATCH only going forward

	SET @wrkDate = GETDATE()
	SET @colWeek = dbo.RRcolectionWeek(@wrkDate)
	SET @endDate = DATEADD(day, 7, @wrkDate)
	SET @currDay = DATENAME(dw,@wrkDate)

	DECLARE @isExcep as int
			,@loopDate as date
			,@lcount as int
			,@chkCount as int
			,@useDate as date
			,@useFDay as varchar(50)

--loop for 7 days
	WHILE @wrkDate < @endDate
	BEGIN
		SET @isExcep = 0
--if day of week in Rub add day to list
--then add next 11 using + 7 days
		IF CHARINDEX(@currDay, @daysRef) > 0
		BEGIN
			SET @loopDate = @wrkDate
			SET @lcount = 1
			SET @chkCount = 1
			WHILE @lcount < 11
			BEGIN
				SET @useDate = @loopDate
				--for the first one to display on summary of next collection 
				IF @lcount <= @noRef
					SET @useFDay = dbo.friendlyDay(@useDate)
				ELSE
					SET @useFDay = DATENAME(dw, @useDate)
				
				INSERT INTO @TempDates
						(colDate, DayOfCol, DateOfCol, TypeOfCol, isExcep)
					VALUES
						(@useDate, @useFDay, dbo.friendlyDate(@useDate), 'Rubbish', @isExcep);
			
				SET @loopDate = DATEADD(day, 7, @loopDate)
				SET @lcount = @lcount + 1
				SET @chkCount = @chkCount + 1
				IF @chkCount > 30
					SET @lcount = @chkCount
			END
		END
--if day of week in Rec
		IF CHARINDEX(@currDay, @daysRec) > 0
		BEGIN
			SET @loopDate = @wrkDate
			SET @lcount = 1
			SET @chkCount = 1
--	if recWk is 0 then add day to list and next 11 using + 7 days
			IF @recWeek = 0
			BEGIN
				WHILE @lcount < 11
				BEGIN
					SET @useDate = @loopDate
					--for the first one to display on summary of next collection 
					IF @lcount <= @noRec
						SET @useFDay = dbo.friendlyDay(@useDate)
					ELSE
						SET @useFDay = DATENAME(dw, @useDate)
					
					INSERT INTO @TempDates
							(colDate, DayOfCol, DateOfCol, TypeOfCol, isExcep)
						VALUES
							(@useDate, @useFDay, dbo.friendlyDate(@useDate), 'Recycling', @isExcep);
				
					SET @loopDate = DATEADD(day, 7, @loopDate)
					SET @lcount = @lcount + 1
					SET @chkCount = @chkCount + 1
					IF @chkCount > 30
						SET @lcount = @chkCount
				END
			END
			ELSE
			BEGIN
--	else if recWk is curWk then add day to list and next 11 using + 14 days
--	else add 7 days and add to list then add next 11 using + 14 daysWHILE @lcount < 10
				IF @recWeek != @colWeek
					SET @loopDate = DATEADD(day, 7, @loopDate)
				
				WHILE @lcount < 11
				BEGIN
					SET @useDate = @loopDate
					--for the first one to display on summary of next collection 
					IF @lcount <= @noRec
						SET @useFDay = dbo.friendlyDay(@useDate)
					ELSE
						SET @useFDay = DATENAME(dw, @useDate)
					
					INSERT INTO @TempDates
							(colDate, DayOfCol, DateOfCol, TypeOfCol, isExcep)
						VALUES
							(@useDate, @useFDay, dbo.friendlyDate(@useDate), 'Recycling', @isExcep);
				
					SET @loopDate = DATEADD(day, 14, @loopDate)
					SET @lcount = @lcount + 1
					SET @chkCount = @chkCount + 1
					IF @chkCount > 30
						SET @lcount = @chkCount
				END
			END
		END
--increase day by 1
		SET @wrkDate = DATEADD(day, 1, @wrkDate)
		SET @currDay = DATENAME(dw,@wrkDate)
--if day of week is monday then change curr week to other as gone to next week
		IF @currDay = 'Monday'
		BEGIN
			IF @colWeek = 1
				SET @colWeek = 2;
			ELSE
				SET @colWeek = 1;
		END
	END
--end loop 7 days

	--SELECT * from @TempDates

	DECLARE @ResultText as varchar(2000)
			,@refList as varchar(2000)
			,@recList as varchar(2000)

    
    IF @noRef = 2
    BEGIN
		SET @ResultText = 'Rubbish collections: 
							<ul><li><strong>' + ISNULL((SELECT top(1) DayOfCol 
														  from @TempDates 
														 where TypeOfCol = 'Rubbish'
													  order by colDate), 'information not found') + '</strong></li>
							<li><strong>' + ISNULL((SELECT DayOfCol 
													from (SELECT ROW_NUMBER() over (order by colDate) as 'rowNum'
																, DayOfCol 
														    from @TempDates 
														   where TypeOfCol = 'Rubbish') withRowNum 
													where rowNum = 2), 'information not found') + '</strong></li></ul></li><li><strong> - ';
    END
	ELSE
    BEGIN
		SET @ResultText ='Rubbish collection ' + ISNULL((SELECT top(1) DayOfCol 
																		  from @TempDates 
																		 where TypeOfCol = 'Rubbish' 
																	  order by colDate), 'information not found') + '</strong></li><li><strong> - ';
    END
    
    SET @ResultText = @ResultText + 'Recycling collection ' + ISNULL((SELECT top(1) DayOfCol from @TempDates where TypeOfCol = 'Recycling'  order by colDate), 'information not found');

    SET @refList = ''
	SET @recList = ''

	SELECT TOP(10) @refList = @refList + '<br />' + DateOfCol + CASE WHEN @isExcep = 1 THEN '*' ELSE '' END
	  FROM @TempDates 
	 WHERE TypeOfCol = 'Rubbish'
  ORDER BY colDate 

	SELECT TOP(10) @recList = @recList + '<br />' + DateOfCol + CASE WHEN @isExcep = 1 THEN '*' ELSE '' END
	  FROM @TempDates 
	 WHERE TypeOfCol = 'Recycling' 
  ORDER BY colDate

	SELECT @ResultText as nextLastHTML
			,@refList as listRefDatesHTML
			,@recList as listRecDatesHTML
			,@uprn_out as uprn_out
			,'complete' as intRun2
END
