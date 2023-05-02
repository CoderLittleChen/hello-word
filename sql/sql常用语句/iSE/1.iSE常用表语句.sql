select  * from  Sync_Employee  where  Name='马伟海'
--模板表（通用页面）
SELECT * FROM dbo.specMS_TemplateSpec
--模板与基线的关系表
SELECT * FROM dbo.specMS_TemplateSpecBLRel

select  *  from  specMS_PredefineParam  a;

--归档常量表
select  *  from  specMS_AppConstant  ;

--系统常量表
select  *  from  specMS_Dict;

select  *  from  specMS_AppConstantValue  order by CreationDate desc ;

--基线表
select * from [dbo].[specMS_SpecBaseLine]
--基线标签
select * from [dbo].[specMS_SpecBaseLineLabel]
--基线规格关系表
select* from [dbo].[specMS_SpecBLEntryRel]
--规格表
select *from [dbo].[specMS_SpecEntry]
--规格内容表
select * from [dbo].[specMS_SpecEntryContent]
--扩展列表
--select top 100 * from [dbo].[specMS_SpecListExtColData]
--规格参数表
select * from [dbo].[specMS_EntryParam]
--标准协议表
select *  from [dbo].[specMS_Standard]
--标准协议与规格及扩展咧的关系表
select * from [dbo].[specMS_StandardSupport]

---------------------一下四张表为新增表-----------------
--规格内容扩展表
SELECT * FROM [dbo].[specMS_EntryContentExt]
--产品列及模板与产品列的关系表
SELECT * FROM [dbo].[specMS_ProductColumn]
--drop table [specMS_ProductColumn]
--产品列内容表
SELECT * FROM [dbo].[specMS_ProColContent]
--drop table [specMS_ProColContent]
--引用产品列视图表
SELECT * FROM [dbo].[specMS_TempBaselineRel]
--drop table [specMS_TempBaselineRel]

--Sol 开头为解决方案相关表  release2新增


ALTER TABLE [dbo].[specMS_EntryContentExt]  ADD  verStatus  INT  DEFAULT(0)   NOT NULL;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-1可撤销0草稿1基线-2备份数据' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMS_EntryContentExt', @level2type=N'COLUMN',@level2name=N'verStatus';

ALTER TABLE [dbo].[specMS_ProColContent]  ADD  verStatus  INT  DEFAULT(0)   NOT NULL;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-1可撤销0草稿1基线-2备份数据' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMS_ProColContent', @level2type=N'COLUMN',@level2name=N'verStatus'
