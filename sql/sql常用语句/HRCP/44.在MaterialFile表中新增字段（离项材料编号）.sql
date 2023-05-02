select   a.MaterialFileNo   from  MaterialFile  a;


--离项材料编号   LeaveMaterialFileNo    
--新增字段语句
--Alter  table   MaterialFile   add    MaterialLeaveFileNo  varchar(50)  null;

execute sp_rename 'MaterialFile.LeaveMaterialFileNo','MaterialLeaveFileNo'
--新建函数  目的是在初次创建新增数据的时候   自动生成该条数据对应的离项材料编号


--新建函数
--Alter FUNCTION [dbo].[F_GetSerialProjectLeaveFileCode](

--)
--RETURNS nvarchar(20)
--AS
--BEGIN
--	DECLARE @LeaveFileCode nvarchar(20)
--	DECLARE @tempLeaveFileCode  nvarchar(20)
--	SELECT TOP 1  @tempLeaveFileCode=mf.MaterialLeaveFileNo FROM MaterialFile mf 
--	inner join ProjectPersonInfo pf ON mf.PersonInfoId=pf.ProjectPersonInfoId WHERE convert(varchar(4),mf.CreateDate,112)=convert(varchar(4),Getdate(),112) AND pf.DeleteFlag=0  order by mf.MaterialLeaveFileNo desc
--	IF(@tempLeaveFileCode  is not  null)
--		BEGIN
--            set @LeaveFileCode=cast(@tempLeaveFileCode as numeric(18,0))+1
--		END
--	ELSE
--		BEGIN
--			set @LeaveFileCode=(cast(convert(varchar(4),Getdate(),112) as nvarchar(20))+'0001')
--		END
--	return @LeaveFileCode
--END