USE [PersonalInput]
GO

/****** Object:  StoredProcedure [dbo].[P_DeptManagerView]    Script Date: 2020/2/10 10:38:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:     ys2338 部门主管视图
-- =============================================
ALTER PROCEDURE [dbo].[P_DeptManagerView]
	@rows INT,--显示条数 如果是导出前两项为0
	@page INT,--显示页码
	@DeptCodes NVARCHAR(MAX),--部门编码 查询条件可多个组合，用逗号隔开,管理员默认传空，其他则根据各自权限,字符串不带引号 普通人员为拥有的权限，管理员为空
	@LongDate VARCHAR(100),--日期 具体到月
	@UserCode NVARCHAR(100),--查询的用户工号
	@ProCode NVARCHAR(100),--项目编码
	@Station NVARCHAR(MAX),--岗位 可多个组合，用逗号隔开
	@deptTreeNode NVARCHAR(MAX),--选择的部门 可多个组合，用逗号隔开,字符串不带引号
	@ProtreeNode NVARCHAR(MAX),----产品编码 可多个组合，用逗号隔开
    @startDate DATETIME ,--时间区间开始
    @endDate DATETIME ,--时间区间结束
    @ProjectLevel VARCHAR(50) ,--项目层级
    @isFill VARCHAR(10),--5未反馈 6反馈 7返回修改
	@OrderByColumn NVARCHAR(500),--排序字段
	@RowID NVARCHAR(MAX),--导出是勾选数据的id
	@ExportFlag CHAR(1) --0为查询，1为导出
AS
    BEGIN
        DECLARE @SQL NVARCHAR(MAX);SET @SQL=''
		DECLARE @SQLSuffix NVARCHAR(MAX); SET @SQLSuffix=''

		DECLARE @WeekDay INT--月末那天是星期几
        SET datefirst 1
		SET @WeekDay= datepart(weekday, @endDate)
		DECLARE @PreDateTime DATETIME; --上个月1号
		SET @PreDateTime=CONVERT(nvarchar(50),Year(DATEADD(MONTH,-1,GETDATE()))) +'-' +  CONVERT(nvarchar(50),MONTH(DATEADD(MONTH,-1,GETDATE()))) + '-'+ CONVERT(nvarchar(50),1) 


		--ys2338 本月取到当前日期
		IF(MONTH(@endDate)=MONTH(GETDATE()))
			BEGIN
				SET @endDate=GETDATE()
			END

		DECLARE @whereRowIDs NVARCHAR(MAX); SET @whereRowIDs='';
		--rowID选中 应用于导出勾选
		IF(@RowID<>'')
		BEGIN
			DECLARE @Split_RowID NVARCHAR(MAX);
			IF(CHARINDEX(',',@RowID)>0)
				BEGIN
				--SET @Split_RowID='select tableColumn from F_SplitStrToTable('''+@RowID+''')';
				SET @Split_RowID='SELECT '''+ REPLACE(@RowID,',',''' UNION ALL SELECT ''')+''''
				END
			ELSE
				BEGIN
				SET @Split_RowID=''''+isnull(@RowID,'')+'''';
				END

			SET @whereRowIDs=' where RowID  in ('+@Split_RowID+')';
		END


		IF @endDate<@PreDateTime AND @WeekDay<7 AND DATEADD(MONTH,1,@startDate)>=@PreDateTime  --历史和当前表拿数据
		BEGIN
			--选择了反馈或请假的数据
			--IF (CHARINDEX('6',@isFill)>0 OR CHARINDEX('7',@isFill)>0 OR @isFill='')
			BEGIN
				IF (@deptTreeNode <> '' ) --选择部门	
				BEGIN
					SET @SQL=@SQL+'
						SELECT * INTO #tabPerAll FROM(
						SELECT *
						FROM(
						SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
								p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
								u.Code UserCode, u.Name UserName,u.Station,
								v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
								v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
						FROM    V_HourInfoFeedBack v
						LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
						LEFT JOIN UserInfo u ON v.UserCode=u.Code
						WHERE   1=1 
						AND v.DeptCode in('+@deptTreeNode+')
						UNION
						SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
								p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
								u.Code UserCode, u.Name UserName,u.Station,
								v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
								v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
						FROM    V_HourInfoFeedBack v
						LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
						LEFT JOIN UserInfo u ON v.UserCode=u.Code
						WHERE   1=1 
						AND v.SecondDeptCode in('+@deptTreeNode+')
						)v
						WHERE 1=1'
				END
				ELSE
				BEGIN
					SET @SQL=@SQL+'
						SELECT * INTO #tabPerAll FROM(
							SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
									p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
									u.Code UserCode, u.Name UserName,u.Station,
									v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
									v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
							FROM    V_HourInfoFeedBack v
							LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
							LEFT JOIN UserInfo u ON v.UserCode=u.Code
							WHERE 1=1 '
				END

				SET @SQL=@SQL+'	AND v.Mon_Date BETWEEN '''+CONVERT(varchar(100), @startDate, 110)+''' AND '''+CONVERT(varchar(100), @endDate, 110) +''''

				IF (@DeptCodes <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND v.DeptCode IN('+ @DeptCodes+' )'
				END		
				IF (@Station <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND Station IN('+ @Station+' )'
				END			
				IF (@ProtreeNode <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND v.ProCode IN('+ @ProtreeNode+' )'
				END	
				IF (@ProCode <> '' )		
				BEGIN
				--	SET @SQL=@SQL+ ' AND v.ProCode='''+@ProCode+''''
					SET @SQL=@SQL+ ' AND (FirstProCode='''+@ProCode+''' OR SecondProCode='''+@ProCode+''' OR ThirdProCode='''+@ProCode+''' OR FourthProCode='''+@ProCode+''') '
				END			
				IF (@UserCode <> '' )		
				BEGIN
					SET @SQL=@SQL+ ' AND v.UserCode='''+@UserCode+''''
				END	
				IF (@LongDate <> '' )		
				BEGIN
					SET @SQL=@SQL+ ' AND v.Mon_Date='''+@LongDate+''''
				END	
				---------------------从历史表取数-------------------------------
				IF (@deptTreeNode <> '' ) --选择部门	
				BEGIN
					SET @SQL=@SQL+'
						UNION ALL
						SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
								p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
								u.Code UserCode, u.Name UserName,u.Station,
								v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
								v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
						FROM    V_HourInfoFeedBackHistory v
						LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
						LEFT JOIN UserInfo u ON v.UserCode=u.Code
						WHERE   1=1 
						AND v.DeptCode in('+@deptTreeNode+')
						UNION
						SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
								p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
								u.Code UserCode, u.Name UserName,u.Station,
								v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
								v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
						FROM    V_HourInfoFeedBackHistory v
						LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
						LEFT JOIN UserInfo u ON v.UserCode=u.Code
						WHERE   1=1 
						AND v.SecondDeptCode in('+@deptTreeNode+')
						)v
						WHERE 1=1'
				END
				ELSE
				BEGIN
					SET @SQL=@SQL+'
						UNION ALL
							SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
									p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
									u.Code UserCode, u.Name UserName,u.Station,
									v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
									v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
							FROM    V_HourInfoFeedBackHistory v
							LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
							LEFT JOIN UserInfo u ON v.UserCode=u.Code
							WHERE 1=1 '
				END

				SET @SQL=@SQL+'	AND v.Mon_Date BETWEEN '''+CONVERT(varchar(100), @startDate, 110)+''' AND '''+CONVERT(varchar(100), @endDate, 110) +''''

				IF (@DeptCodes <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND v.DeptCode IN('+ @DeptCodes+' )'
				END		
				IF (@Station <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND Station IN('+ @Station+' )'
				END			
				IF (@ProtreeNode <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND v.ProCode IN('+ @ProtreeNode+' )'
				END	
				IF (@ProCode <> '' )		
				BEGIN
				--	SET @SQL=@SQL+ ' AND v.ProCode='''+@ProCode+''''
					SET @SQL=@SQL+ ' AND (FirstProCode='''+@ProCode+''' OR SecondProCode='''+@ProCode+''' OR ThirdProCode='''+@ProCode+''' OR FourthProCode='''+@ProCode+''') '
				END			
				IF (@UserCode <> '' )		
				BEGIN
					SET @SQL=@SQL+ ' AND v.UserCode='''+@UserCode+''''
				END	
				IF (@LongDate <> '' )		
				BEGIN
					SET @SQL=@SQL+ ' AND v.Mon_Date='''+@LongDate+''''
				END	

				SET @SQL=@SQL+' )tmp 
				'
			END
		END
		ELSE IF (@endDate<@PreDateTime AND @WeekDay=7 AND DATEADD(MONTH,1,@startDate)>=@PreDateTime) OR DATEADD(MONTH,1,@startDate)<@PreDateTime --历史表拿数据
		BEGIN
			--选择了反馈或请假的数据
			--IF (CHARINDEX('6',@isFill)>0 OR CHARINDEX('7',@isFill)>0 OR @isFill='')
			BEGIN
				IF (@deptTreeNode <> '' ) --选择部门	
				BEGIN
					SET @SQL=@SQL+'
						SELECT * INTO #tabPerAll
						FROM(
						SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
								p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
								u.Code UserCode, u.Name UserName,u.Station,
								v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
								v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
						FROM    V_HourInfoFeedBackHistory v
						LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
						LEFT JOIN UserInfo u ON v.UserCode=u.Code
						WHERE   1=1 
						AND v.DeptCode in('+@deptTreeNode+')
						UNION
						SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
								p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
								u.Code UserCode, u.Name UserName,u.Station,
								v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
								v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
						FROM    V_HourInfoFeedBackHistory v
						LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
						LEFT JOIN UserInfo u ON v.UserCode=u.Code
						WHERE   1=1 
						AND v.SecondDeptCode in('+@deptTreeNode+')
						)v
						WHERE 1=1'
				END
				ELSE
				BEGIN
					SET @SQL=@SQL+'
							SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
									p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
									u.Code UserCode, u.Name UserName,u.Station,
									v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
									v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
							INTO #tabPerAll
							FROM    V_HourInfoFeedBackHistory v
							LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
							LEFT JOIN UserInfo u ON v.UserCode=u.Code
							WHERE 1=1 '
				END

				SET @SQL=@SQL+'	AND v.Mon_Date BETWEEN '''+CONVERT(varchar(100), @startDate, 110)+''' AND '''+CONVERT(varchar(100), @endDate, 110) +''''

				IF (@DeptCodes <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND v.DeptCode IN('+ @DeptCodes+' )'
				END		
				IF (@Station <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND Station IN('+ @Station+' )'
				END			
				IF (@ProtreeNode <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND v.ProCode IN('+ @ProtreeNode+' )'
				END	
				IF (@ProCode <> '' )		
				BEGIN
				--	SET @SQL=@SQL+ ' AND v.ProCode='''+@ProCode+''''
					SET @SQL=@SQL+ ' AND (FirstProCode='''+@ProCode+''' OR SecondProCode='''+@ProCode+''' OR ThirdProCode='''+@ProCode+''' OR FourthProCode='''+@ProCode+''') '
				END			
				IF (@UserCode <> '' )		
				BEGIN
					SET @SQL=@SQL+ ' AND v.UserCode='''+@UserCode+''''
				END	
				IF (@LongDate <> '' )		
				BEGIN
					SET @SQL=@SQL+ ' AND v.Mon_Date='''+@LongDate+''''
				END	

			END
		END
		ELSE IF @startDate>=@PreDateTime --当前表拿数据
		BEGIN
			--选择了反馈或请假的数据
			--IF (CHARINDEX('6',@isFill)>0 OR CHARINDEX('7',@isFill)>0 OR @isFill='')
			BEGIN
				IF (@deptTreeNode <> '' ) --选择部门	
				BEGIN
					SET @SQL=@SQL+'
						SELECT * INTO #tabPerAll
						FROM(
						SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
								p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
								u.Code UserCode, u.Name UserName,u.Station,
								v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
								v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
						FROM    V_HourInfoFeedBack v
						LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
						LEFT JOIN UserInfo u ON v.UserCode=u.Code
						WHERE   1=1 
						AND v.DeptCode in('+@deptTreeNode+')
						UNION
						SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
								p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
								u.Code UserCode, u.Name UserName,u.Station,
								v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
								v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
						FROM    V_HourInfoFeedBack v
						LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
						LEFT JOIN UserInfo u ON v.UserCode=u.Code
						WHERE   1=1 
						AND v.SecondDeptCode in('+@deptTreeNode+')
						)v
						WHERE 1=1'
				END
				ELSE
				BEGIN
					SET @SQL=@SQL+'
							SELECT p.ProductLineName ,p.ProductLineCode,p.PDTName , p.PDTCode , p.FirstProID,p.FirstProCode , p.FirstProName,p.SecondProID,p.SecondProCode,p.SecondProName ,
									p.ThirdProID, p.ThirdProName, p.ThirdProCode, p.FourthProID, p.FourthProName, p.FourthProCode, 
									u.Code UserCode, u.Name UserName,u.Station,
									v.Mon_Date,v.Mon_Percents,v.DeptCode,v.DeptName,v.SecondDeptCode,SecondDeptName,v.FillState,
									v.isReview,v.Remark,v.parentID,v.ProID,v.ProCode
							INTO #tabPerAll
							FROM    V_HourInfoFeedBack v
							LEFT JOIN ProductInfo_Display p ON v.ProID = p.Current_ProId
							LEFT JOIN UserInfo u ON v.UserCode=u.Code
							WHERE 1=1 '
				END

				SET @SQL=@SQL+'	AND v.Mon_Date BETWEEN '''+CONVERT(varchar(100), @startDate, 110)+''' AND '''+CONVERT(varchar(100), @endDate, 110) +''''

				IF (@DeptCodes <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND v.DeptCode IN('+ @DeptCodes+' )'
				END		
				IF (@Station <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND Station IN('+ @Station+' )'
				END			
				IF (@ProtreeNode <> '' )
				BEGIN
					SET @SQL=@SQL+ ' AND v.ProCode IN('+ @ProtreeNode+' )'
				END	
				IF (@ProCode <> '' )		
				BEGIN
				--	SET @SQL=@SQL+ ' AND v.ProCode='''+@ProCode+''''
					SET @SQL=@SQL+ ' AND (FirstProCode='''+@ProCode+''' OR SecondProCode='''+@ProCode+''' OR ThirdProCode='''+@ProCode+''' OR FourthProCode='''+@ProCode+''') '
				END			
				IF (@UserCode <> '' )		
				BEGIN
					SET @SQL=@SQL+ ' AND v.UserCode='''+@UserCode+''''
				END	
				IF (@LongDate <> '' )		
				BEGIN
					SET @SQL=@SQL+ ' AND v.Mon_Date='''+@LongDate+''''
				END	

			END
		END


		

		--如果勾选了未反馈的，则需要获得未反馈记录
        IF (CHARINDEX('5',@isFill)>0 OR @isFill='')
		BEGIN
				--未反馈数据
				IF ( @ProCode <> '' OR @ProtreeNode<>'')	--选择单独的产品编码，或者产品树 未反馈则为空
				BEGIN
					SET @SQL=@SQL+'SELECT  * 
					INTO    #InitailHourInfo
					FROM(
					SELECT  ProductLineName ,'''' ProductLineCode ,PDTName ,'''' PDTCode ,FirstProID ,FirstProCode ,FirstProName ,''00000000-0000-0000-0000-000000000000'' SecondProID ,
							'''' SecondProCode ,'''' SecondProName ,''00000000-0000-0000-0000-000000000000'' ThirdProID ,'''' ThirdProName ,'''' ThirdProCode ,''00000000-0000-0000-0000-000000000000'' FourthProID ,
							'''' FourthProName ,'''' FourthProCode ,UserCode ,UserName ,Mon_Date ,CONVERT(FLOAT, 0) Mon_Percents ,DeptCode ,SecondDeptCode ,DeptName ,SecondDeptName ,Station ,NULL FillState ,
							0 isReview ,'''' Remark ,parentID ,''00000000-0000-0000-0000-000000000000'' ProID
					FROM    [dbo].[UnFeedBackHourInfo]
					WHERE   1=2
					) unfeedback 
					'
				END
				ELSE
				BEGIN
					IF (@deptTreeNode <> '' ) --选择部门	
					BEGIN
					SET @SQL=@SQL+'SELECT  * 
						INTO    #InitailHourInfo
						FROM(
						SELECT  ProductLineName ,'''' ProductLineCode ,PDTName ,'''' PDTCode ,FirstProID ,FirstProCode ,FirstProName ,''00000000-0000-0000-0000-000000000000'' SecondProID ,
								'''' SecondProCode ,'''' SecondProName ,''00000000-0000-0000-0000-000000000000'' ThirdProID ,'''' ThirdProName ,'''' ThirdProCode ,''00000000-0000-0000-0000-000000000000'' FourthProID ,
								'''' FourthProName ,'''' FourthProCode ,UserCode ,UserName ,Mon_Date ,CONVERT(FLOAT, 0) Mon_Percents ,i.DeptCode ,SecondDeptCode ,i.DeptName ,SecondDeptName ,u.Station ,NULL FillState ,
								0 isReview ,'''' Remark ,parentID ,''00000000-0000-0000-0000-000000000000'' ProID
						FROM    [dbo].[UnFeedBackHourInfo] i
						INNER JOIN UserInfo u ON i.UserCode=u.Code
						WHERE  1=1 
						AND i.DeptCode in('+@deptTreeNode+')
						UNION
						SELECT  ProductLineName ,'''' ProductLineCode ,PDTName ,'''' PDTCode ,FirstProID ,FirstProCode ,FirstProName ,''00000000-0000-0000-0000-000000000000'' SecondProID ,
								'''' SecondProCode ,'''' SecondProName ,''00000000-0000-0000-0000-000000000000'' ThirdProID ,'''' ThirdProName ,'''' ThirdProCode ,''00000000-0000-0000-0000-000000000000'' FourthProID ,
								'''' FourthProName ,'''' FourthProCode ,UserCode ,UserName ,Mon_Date ,CONVERT(FLOAT, 0) Mon_Percents ,i.DeptCode ,SecondDeptCode ,i.DeptName ,SecondDeptName ,u.Station ,NULL FillState ,
								0 isReview ,'''' Remark ,parentID ,''00000000-0000-0000-0000-000000000000'' ProID
						FROM    [dbo].[UnFeedBackHourInfo] i
						INNER JOIN UserInfo u ON i.UserCode=u.Code
						WHERE  1=1 
						AND i.SecondDeptCode in('+@deptTreeNode+')
						)u WHERE 1=1 
						'
					END
					ELSE
					BEGIN
						SET @SQL=@SQL+'SELECT  * 
						INTO    #InitailHourInfo
						FROM(
							SELECT  ProductLineName ,'''' ProductLineCode ,PDTName ,'''' PDTCode ,FirstProID ,FirstProCode ,FirstProName ,''00000000-0000-0000-0000-000000000000'' SecondProID ,
									'''' SecondProCode ,'''' SecondProName ,''00000000-0000-0000-0000-000000000000'' ThirdProID ,'''' ThirdProName ,'''' ThirdProCode ,''00000000-0000-0000-0000-000000000000'' FourthProID ,
									'''' FourthProName ,'''' FourthProCode ,UserCode ,UserName ,Mon_Date ,CONVERT(FLOAT, 0) Mon_Percents ,i.DeptCode ,SecondDeptCode ,i.DeptName ,SecondDeptName ,u.Station ,NULL FillState ,
									0 isReview ,'''' Remark ,parentID ,''00000000-0000-0000-0000-000000000000'' ProID
							FROM    [dbo].[UnFeedBackHourInfo] i
							INNER JOIN UserInfo u ON i.UserCode=u.Code
							WHERE  1=1 )u where 1=1 '
					END

				    SET @SQL=@SQL+ 'AND Mon_Date BETWEEN '''+CONVERT(varchar(100), @startDate, 110)+''' AND '''+CONVERT(varchar(100), @endDate, 110)+''''
				    IF (@DeptCodes <> '' )
				    BEGIN
				 	    SET @SQL=@SQL+ ' AND u.DeptCode IN('+ @DeptCodes+' )'
				    END	
				    IF (@Station <> '' )
				    BEGIN
						SET @SQL=@SQL+ ' AND u.Station IN('+ @Station+' )'
				    END
					IF (@UserCode <> '' )		
					BEGIN
						SET @SQL=@SQL+ ' AND UserCode='''+@UserCode+''''
					END	
					IF (@LongDate <> '' )		
					BEGIN
						SET @SQL=@SQL+ ' AND Mon_Date='''+@LongDate+''''
					END	

					 --  SET @SQL=@SQL+') unfeedback '
				END
        END;

		--对5:未反馈、6:已反馈、7:返回修改三个状态，选择不同的数据源
		IF ( @isFill = '5' )
            BEGIN 
                SET @SQL = @SQL
                    + ' select * into #dataSource from(
					select * from #InitailHourInfo
					union all
					select ProductLineName ,ProductLineCode,PDTName , PDTCode , ISNULL(FirstProID,''00000000-0000-0000-0000-000000000000'') FirstProID,FirstProCode , FirstProName,ISNULL(SecondProID,''00000000-0000-0000-0000-000000000000'') SecondProID,SecondProCode,SecondProName ,
							ISNULL(ThirdProID,''00000000-0000-0000-0000-000000000000'') ThirdProID, ThirdProName, ThirdProCode, ISNULL(FourthProID,''00000000-0000-0000-0000-000000000000'') FourthProID, FourthProName, FourthProCode, UserCode, UserName,Mon_Date,Mon_Percents,DeptCode,SecondDeptCode,
							DeptName,SecondDeptName,Station,FillState,
							isReview,Remark,parentID,ProID
						from #tabPerAll
						where FillState=1
					)source'
            END;
		ELSE IF(@isFill = '6' )
			BEGIN
				SET @SQL = @SQL
                        + 'select * into #dataSource from(
							select ProductLineName ,ProductLineCode,PDTName , PDTCode , ISNULL(FirstProID,''00000000-0000-0000-0000-000000000000'') FirstProID,FirstProCode , FirstProName,ISNULL(SecondProID,''00000000-0000-0000-0000-000000000000'') SecondProID,SecondProCode,SecondProName ,
							ISNULL(ThirdProID,''00000000-0000-0000-0000-000000000000'') ThirdProID, ThirdProName, ThirdProCode, ISNULL(FourthProID,''00000000-0000-0000-0000-000000000000'') FourthProID, FourthProName, FourthProCode, UserCode, UserName,Mon_Date,Mon_Percents,DeptCode,SecondDeptCode,
							DeptName,SecondDeptName,Station,FillState,
							isReview,Remark,parentID,ProID
						from #tabPerAll
						where FillState=0
						)source'
			END
        ELSE IF (@isFill = '7')
			BEGIN
				SET @SQL = @SQL
                        + 'select * into #dataSource from(
							select ProductLineName ,ProductLineCode,PDTName , PDTCode , ISNULL(FirstProID,''00000000-0000-0000-0000-000000000000'') FirstProID,FirstProCode , FirstProName,ISNULL(SecondProID,''00000000-0000-0000-0000-000000000000'') SecondProID,SecondProCode,SecondProName ,
							ISNULL(ThirdProID,''00000000-0000-0000-0000-000000000000'') ThirdProID, ThirdProName, ThirdProCode, ISNULL(FourthProID,''00000000-0000-0000-0000-000000000000'') FourthProID, FourthProName, FourthProCode, UserCode, UserName,Mon_Date,Mon_Percents,DeptCode,SecondDeptCode,
							DeptName,SecondDeptName,Station,FillState,
							isReview,Remark,parentID,ProID
						from #tabPerAll
						where FillState=1
						)source'
			END
		ELSE IF(@isFill = '5,6')
			BEGIN
					SET @SQL = @SQL
                        + ' select * into #dataSource from(
						select ProductLineName ,ProductLineCode,PDTName , PDTCode , ISNULL(FirstProID,''00000000-0000-0000-0000-000000000000'') FirstProID,FirstProCode , FirstProName,ISNULL(SecondProID,''00000000-0000-0000-0000-000000000000'') SecondProID,SecondProCode,SecondProName ,
							ISNULL(ThirdProID,''00000000-0000-0000-0000-000000000000'') ThirdProID, ThirdProName, ThirdProCode, ISNULL(FourthProID,''00000000-0000-0000-0000-000000000000'') FourthProID, FourthProName, FourthProCode, UserCode, UserName,Mon_Date,Mon_Percents,DeptCode,SecondDeptCode,
							DeptName,SecondDeptName,Station,FillState,
							isReview,Remark,parentID,ProID
							from #tabPerAll 
							union all 
							select * from #InitailHourInfo
							)source'
			END
		ELSE IF(@isFill = '5,7')
			BEGIN
					SET @SQL = @SQL
                        + ' select * into #dataSource from(
						select ProductLineName ,ProductLineCode,PDTName , PDTCode , ISNULL(FirstProID,''00000000-0000-0000-0000-000000000000'') FirstProID,FirstProCode , FirstProName,ISNULL(SecondProID,''00000000-0000-0000-0000-000000000000'') SecondProID,SecondProCode,SecondProName ,
							ISNULL(ThirdProID,''00000000-0000-0000-0000-000000000000'') ThirdProID, ThirdProName, ThirdProCode, ISNULL(FourthProID,''00000000-0000-0000-0000-000000000000'') FourthProID, FourthProName, FourthProCode, UserCode, UserName,Mon_Date,Mon_Percents,DeptCode,SecondDeptCode,
							DeptName,SecondDeptName,Station,FillState,
							isReview,Remark,parentID,ProID
							from #tabPerAll where FillState=1
							union all 
							select * from #InitailHourInfo
							)source'
			END
		ELSE IF(@isFill = '6,7')
			BEGIN
					SET @SQL = @SQL
                        + ' select * into #dataSource from(
						select ProductLineName ,ProductLineCode,PDTName , PDTCode , ISNULL(FirstProID,''00000000-0000-0000-0000-000000000000'') FirstProID,FirstProCode , FirstProName,ISNULL(SecondProID,''00000000-0000-0000-0000-000000000000'') SecondProID,SecondProCode,SecondProName ,
							ISNULL(ThirdProID,''00000000-0000-0000-0000-000000000000'') ThirdProID, ThirdProName, ThirdProCode, ISNULL(FourthProID,''00000000-0000-0000-0000-000000000000'') FourthProID, FourthProName, FourthProCode, UserCode, UserName,Mon_Date,Mon_Percents,DeptCode,SecondDeptCode,
							DeptName,SecondDeptName,Station,FillState,
							isReview,Remark,parentID,ProID
							from #tabPerAll 

							)source'
			END
        ELSE IF ( @isFill='5,6,7' or @isFill='')
            BEGIN
                    SET @SQL = @SQL
                        + ' select * into #dataSource from(
						select ProductLineName ,ProductLineCode,PDTName , PDTCode , ISNULL(FirstProID,''00000000-0000-0000-0000-000000000000'') FirstProID,FirstProCode , FirstProName,ISNULL(SecondProID,''00000000-0000-0000-0000-000000000000'') SecondProID,SecondProCode,SecondProName ,
							ISNULL(ThirdProID,''00000000-0000-0000-0000-000000000000'') ThirdProID, ThirdProName, ThirdProCode, ISNULL(FourthProID,''00000000-0000-0000-0000-000000000000'') FourthProID, FourthProName, FourthProCode, UserCode, UserName,Mon_Date,Mon_Percents,DeptCode,SecondDeptCode,
							DeptName,SecondDeptName,Station,FillState,
							isReview,Remark,parentID,ProID
							from #tabPerAll
							union all 
							select * from #InitailHourInfo
							)source'
            END;

		--记录总和、权重总和声明
		SET @SQL = @SQL+' DECLARE @SumNum INT,@SumAll float;'

		--按照项目层级分组
        IF ( @ProjectLevel = '2' )
            BEGIN
					    SET @SQLSuffix=@SQLSuffix+ 'select @SumNum=count(*) ,@SumAll= CONVERT(float,SUM(Mon_Percents))
												from(
												select CONVERT(float,SUM(Mon_Percents)) Mon_Percents
												FROM #dataSource  
												group by  UserCode,Mon_Date,FillState,parentID,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID, SecondProCode,SecondProName,SecondProID
												)main
												select * into #temp from(
										select UserCode,Mon_Date,FillState,CONVERT(float,SUM(Mon_Percents)) Mon_Percents  ,/*Max(Remark) as Remark,*/pr.parentID ,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID, SecondProCode,SecondProName,SecondProID
										from (select * from #dataSource) pr  '  
                            + ' group by  UserCode,Mon_Date,FillState,pr.parentID,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID, SecondProCode,SecondProName,SecondProID  '
						IF(@ExportFlag='0' OR(@ExportFlag='1' And @RowID<>''))
						BEGIN
						SET @SQLSuffix=@SQLSuffix+'
						order by UserCode,Mon_Date desc 
						offset '
						SET @SQLSuffix=@SQLSuffix
						 + CAST(( ( @page * @rows ) - @rows ) AS VARCHAR(10))
						 + ' rows fetch next ' + CAST(@rows AS VARCHAR(10))
                            + ' rows only';
						END
						SET @SQLSuffix=@SQLSuffix+' )temp'
						-----------------------------------------------------------------------------------------------------------------------------------------------------------------
						SET @SQLSuffix = @SQLSuffix +' SELECT * INTO #SelectAllPro FROM(
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.FirstProID
							Where temp.FirstProCode<>'''' And temp.SecondProCode=''''
							UNION ALL
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.SecondProID
							Where temp.SecondProCode<>''''
							UNION ALL
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.SecondProID
							Where temp.ProductLineCode='''' --未反馈的
							)Main'
            END;	
        ELSE IF ( @ProjectLevel = '3' )
			BEGIN
					    SET @SQLSuffix=@SQLSuffix+ 'select @SumNum=count(*) ,@SumAll= CONVERT(float,SUM(Mon_Percents))
												from(
												select CONVERT(float,SUM(Mon_Percents)) Mon_Percents
												FROM #dataSource  
												group by  UserCode,Mon_Date,FillState,parentID,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID, SecondProCode,SecondProName,SecondProID, ThirdProCode,ThirdProName,ThirdProID
												)main
											select * into #temp from(
										select UserCode,Mon_Date,FillState,CONVERT(float,SUM(Mon_Percents)) Mon_Percents  ,/*Max(Remark) as Remark,*/pr.parentID ,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID, SecondProCode,SecondProName,SecondProID, ThirdProCode,ThirdProName,ThirdProID
										from (select * from #dataSource) pr  '  
                            + ' group by  UserCode,Mon_Date,FillState,pr.parentID,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID, SecondProCode,SecondProName,SecondProID, ThirdProCode,ThirdProName,ThirdProID  '
						IF(@ExportFlag='0' OR(@ExportFlag='1' And @RowID<>''))
						BEGIN
						SET @SQLSuffix=@SQLSuffix+'
						order by UserCode,Mon_Date desc 
						offset '
						SET @SQLSuffix=@SQLSuffix
						 + CAST(( ( @page * @rows ) - @rows ) AS VARCHAR(10))
						 + ' rows fetch next ' + CAST(@rows AS VARCHAR(10))
                            + ' rows only';
						END
						SET @SQLSuffix=@SQLSuffix+' )temp'
						-----------------------------------------------------------------------------------------------------------------------------------------------------------------
						SET @SQLSuffix = @SQLSuffix +' SELECT * INTO #SelectAllPro FROM(
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.FirstProID
							Where temp.FirstProCode<>'''' And temp.SecondProCode=''''
							UNION ALL
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.SecondProID
							Where temp.SecondProCode<>'''' And temp.ThirdProCode=''''
							UNION ALL
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.ThirdProID
							Where temp.ThirdProCode<>''''
							UNION ALL
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.ThirdProID
							Where temp.ProductLineCode='''' --未反馈的
							)Main'
               END;	
        ELSE IF ( @ProjectLevel = '4' )
            BEGIN
					    SET @SQLSuffix=@SQLSuffix+ 'select @SumNum=count(*) ,@SumAll= CONVERT(float,SUM(Mon_Percents))
												from(
												select CONVERT(float,SUM(Mon_Percents)) Mon_Percents
												FROM #dataSource  
												group by  UserCode,Mon_Date,FillState,parentID,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID, SecondProCode,SecondProName,SecondProID, ThirdProCode,ThirdProName,ThirdProID, FourthProCode,FourthProName,FourthProID
												)main
											select * into #temp from(
										select UserCode,Mon_Date,FillState,CONVERT(float,SUM(Mon_Percents)) Mon_Percents  ,/*Max(Remark) as Remark,*/pr.parentID ,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID, SecondProCode,SecondProName,SecondProID, ThirdProCode,ThirdProName,ThirdProID, FourthProCode,FourthProName,FourthProID
										from (select * from #dataSource) pr  '  
                            + ' group by  UserCode,Mon_Date,FillState,pr.parentID,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID, SecondProCode,SecondProName,SecondProID, ThirdProCode,ThirdProName,ThirdProID, FourthProCode,FourthProName,FourthProID   '
						IF(@ExportFlag='0' OR(@ExportFlag='1' And @RowID<>''))
						BEGIN
						SET @SQLSuffix=@SQLSuffix+'
						order by UserCode,Mon_Date desc 
						offset '
						SET @SQLSuffix=@SQLSuffix
						 + CAST(( ( @page * @rows ) - @rows ) AS VARCHAR(10))
						 + ' rows fetch next ' + CAST(@rows AS VARCHAR(10))
                            + ' rows only';
						END
						SET @SQLSuffix=@SQLSuffix+' )temp'
						-----------------------------------------------------------------------------------------------------------------------------------------------------------------
						SET @SQLSuffix = @SQLSuffix +' SELECT * INTO #SelectAllPro FROM(
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.FirstProID
							Where temp.FirstProCode<>'''' And temp.SecondProCode=''''
							UNION ALL
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.SecondProID
							Where temp.SecondProCode<>'''' And temp.ThirdProCode=''''
							UNION ALL
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.ThirdProID
							Where temp.ThirdProCode<>'''' And temp.FourthProCode=''''
							UNION ALL
							select 
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
							temp.*,
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
							from #temp temp
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
							left join StationCategory station with(nolock) on station.Code=ui.Station
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.FourthProID
							Where temp.FourthProCode<>'''' 
							UNION ALL         
							select          
							depart.SecondDeptName,depart.DeptName,ui.Name as UserName,         
							temp.*,         
							new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName         
							from #temp temp         
							left join UserInfo ui with(nolock) on ui.Code=temp.UserCode         
							left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode         
							left join StationCategory station with(nolock) on station.Code=ui.Station         
							left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And  new.ProID=temp.FourthProID         
							Where temp.ProductLineCode='''' -- 未反馈的      
							)Main'

                    END;	
        ELSE
            BEGIN
					    SET @SQLSuffix=@SQLSuffix+ 'select @SumNum=count(*) ,@SumAll= CONVERT(float,SUM(Mon_Percents))
												from(
												select CONVERT(float,SUM(Mon_Percents)) Mon_Percents
												FROM #dataSource  
												group by  UserCode,Mon_Date,FillState,parentID,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID
												)main
											select * into #temp from(
										select UserCode,Mon_Date,FillState,CONVERT(float,SUM(Mon_Percents)) Mon_Percents  ,/*Max(Remark) as Remark,*/parentID ,ProductLineName,ProductLineCode,PDTName,PDTCode, FirstProCode  ,FirstProName ,FirstProID
										from (select * from #dataSource) pr '  
                            + ' group by  UserCode,Mon_Date,FillState,parentID,ProductLineName,ProductLineCode,PDTName,PDTCode,FirstProCode,FirstProName,FirstProID  '
						IF(@ExportFlag='0' OR(@ExportFlag='1' And @RowID<>''))
						BEGIN
						SET @SQLSuffix=@SQLSuffix+'
						order by UserCode,Mon_Date desc 
						offset '
						SET @SQLSuffix=@SQLSuffix
						 + CAST(( ( @page * @rows ) - @rows ) AS VARCHAR(10))
						 + ' rows fetch next ' + CAST(@rows AS VARCHAR(10))
                            + ' rows only';
						END
						SET @SQLSuffix=@SQLSuffix+' )temp'
						-------------------------------------------------------------------------------------------------------------------------------------------------------------------
						SET @SQLSuffix = @SQLSuffix +' select 
										depart.SecondDeptName,depart.DeptName,ui.Name as UserName,
										temp.*,
										new.Remark,depart.DeptCode,SecondDeptCode,Station, station.Name StationName
										into #SelectAllPro
										from #temp temp
										left join UserInfo ui with(nolock) on ui.Code=temp.UserCode
										left join Department depart with(nolock) on ui.DeptCode=depart.DeptCode
										left join StationCategory station with(nolock) on station.Code=ui.Station
										left join HourInfo_New new with(nolock) on new.HMain_ID=temp.parentID And new.Date=temp.Mon_Date And new.ProID=temp.FirstProID
										
										'
                    END;
		
		--SET @SQLSuffix = @SQLSuffix+' CREATE CLUSTERED INDEX IDX_#tables_NAME ON #SelectAllPro(rowID);' --临时表每次顺序不一样问题
	--	SET @SQLSuffix = @SQLSuffix+' SELECT @SumNum=COUNT(0),@SumAll=sum(Mon_Percents) FROM #SelectAllPro  '+@whereRowIDs+'
	--	SET @SQLSuffix = @SQLSuffix+'select a.*,@SumNum Counts,@SumAll SumAll,b.Name as StationNameShow from #SelectAllPro a left join StationCategory b on a.Station=b.Code '+@whereRowIDs+' order by '
		SET @SQLSuffix = @SQLSuffix+' select * from( select ISNULL(ROW_NUMBER() OVER ( ORDER BY Mon_Date, Mon_Percents, FirstProCode,UserName, DeptCode ),0) rowID , a.*,@SumNum Counts,@SumAll SumAll,a.StationName as StationNameShow from #SelectAllPro a)finalResult '+@whereRowIDs+' order by '
                    + @OrderByColumn ;
					--IF(@rows<>0)
					--BEGIN
					--	SET @SQLSuffix=@SQLSuffix+ ' offset '
					--	+ CAST(( ( @page * @rows ) - @rows ) AS VARCHAR(10))
					--	+ ' rows fetch next ' + CAST(@rows AS VARCHAR(10))
					--	+ ' rows only;';
					--END	
							
		SET @SQLSuffix=@SQLSuffix+' DROP TABLE #SelectAllPro; DROP TABLE #temp; DROP TABLE #dataSource;'
		IF (CHARINDEX('6',@isFill)>0 OR CHARINDEX('7',@isFill)>0 OR @isFill='')
		BEGIN
			SET @SQLSuffix=@SQLSuffix+' DROP TABLE #tabPerAll;'
		END
		IF (CHARINDEX('5',@isFill)>0 OR @isFill='')
		BEGIN
			SET @SQLSuffix=@SQLSuffix+' DROP TABLE #InitailHourInfo;'
		END

      -- EXEC sp_executesql @SQL;
	   exec(@SQL+@SQLSuffix)
	  -- SELECT @SQL+@SQLSuffix

    END;

GO


