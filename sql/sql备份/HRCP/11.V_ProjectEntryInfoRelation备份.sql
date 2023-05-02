USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectEntryInfoRelation]    Script Date: 2019/7/30 10:41:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [dbo].[V_ProjectEntryInfoRelation]
as

select pe.ProjectControlId,pr.*,pf.Name,pf.Sex,pf.IdCard,pf.ProjectCode,pf.EntryDate,pf.ExpiryDate,pf.CooCompany,pe.InfoSafeSignDate,pf.ID,pf.DeptCode2,pf.DeptCode3,pf.CooType,pf.ProjectName
from ProjectEntry_Person_Relation pr
inner join ProjectPersonEntry pe on pe.ProjectPersonEntryId=pr.ProjectPersonEntryId 
left join ProjectPersonInfo pf on pr.ProjectPersonInfoId=pf.ProjectPersonInfoId

GO


