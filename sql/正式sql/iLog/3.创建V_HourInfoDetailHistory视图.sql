USE [PersonalInput]
GO

/****** Object:  View [dbo].[V_HourInfoDetailHistory]    Script Date: 2019/12/7 14:46:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[V_HourInfoDetailHistory]
AS
    SELECT  a.Id ,
            a.HMain_ID ,
            a.ProID ,
            a.Date ,
            a.DayOfWeek ,
            a.Percents ,
            a.FillState ,
            a.IsWorkingDay ,
            c.Creator ,
            a.CreateTime ,
            a.Modifier ,
            a.ModifyTime ,
            a.DeleteFlag ,
			d.FirstProName,
            b.ProName ,
            b.ProCode ,
            a.IsLeave,
			a.Remark,
			a.IsReview,
			b.SuspendTime,
			b.DeleteFlag ProDeleteFlag,
			a.Creator HourInfo_NewCreator,
			a.IsTdms,
			a.TdmsTime
    FROM    dbo.HourInfoDetailHistory a
            LEFT JOIN dbo.ProductInfo b ON a.ProID = b.ProID
			LEFT JOIN dbo.ProductInfo_Display d ON a.ProID = d.Current_ProId
			LEFT JOIN dbo.HourInfoMain c ON a.HMain_ID=c.id
    WHERE   a.DeleteFlag = 0;
GO


