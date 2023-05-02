Alter procedure  P_SyncSolProductInfo
as
	--事务中操作的错误记录
	declare @error int =0
	begin
		--不返回受影响的行数
		set nocount on
		--遇到错误 立刻回滚
		set xact_abort on
		begin try
			begin transaction 
				--创建临时表
				if object_id('tempdb..#solProductInfo') is not null
					begin
						drop table #solProductInfo;
					end
				--先把数据保存到临时表
				select  *  into  #solProductInfo  from   [iSplan].[JSZL].dbo.[View_SolutionProductLineInfo];
				--删除STD经理 二级部门主管  三级部门主管角色
				delete  Sol_PermissionTest 
				where RCode in (55,56,57,58);

				--删除原STD架构师对应的规格责任人角色
				delete Sol_PermissionTest  from  Sol_DataIDSetTest  a  
				inner join Sol_PermissionTest  b on  a.DataSetID=b.DataSetID and b.RCode=1
				inner join Sol_ProductInfoTest c on  a.SrcID=c.D_Code  and  SUBSTRING(c.STDArch,CHARINDEX(' ',c.STDArch)+1,10)=b.UserName
				where  b.RCode=1  
		
				--删除表Sol_ProductInfoTest
				truncate table Sol_ProductInfoTest;

				--将视图数据插入表中
				insert  into Sol_ProductInfoTest
				(
					 [ProductLine_Code]
					,[ProductLine_Name]
					,[iSplanPLine_Code]
					,[PDT_Code]
					,[PDT_Name]
					,[iSplanPDT_Code]
					,[Release_Code]
					,[Release_Name]
					,[iSplanRelease_Code]
					,[B_Code]
					,[B_Name]
					,[D_Code]
					,[D_Name]
					,[STDArch]
					,[STDMgr]
					,[SecondDeptMgr]
					,[ThirdDeptMgr]
				)
				select  
					 [ProductLine_Code]
					,[ProductLine_Name]
					,[iSplanPLine_Code]
					,[PDT_Code]
					,[PDT_Name]
					,[iSplanPDT_Code]
					,[Release_Code]
					,[Release_Name]
					,[iSplanRelease_Code]
					,[B_Code]
					,[B_Name]
					,[D_Code]
					,[D_Name]
					,[STDArch]
					,[STDMgr]
					,[SecondDeptMgr]
					,[ThirdDeptMgr]  from  #solProductInfo;

				--将数据插入Sol_DataSetIDtest
				--导入产品线
				MERGE Sol_DataIDSetTest  AS T
				USING (SELECT pro.ProductLine_Code,pro.ProductLine_Name FROM Sol_ProductInfoTest pro GROUP BY pro.ProductLine_Code,pro.ProductLine_Name)  AS S
				ON T.SrcID=S.ProductLine_Code
				WHEN MATCHED THEN 
					UPDATE SET T.SrcName=S.ProductLine_Name
				WHEN NOT MATCHED THEN 
					INSERT ([SrcID],[SrcPID],[SrcName],[IDLevel],[OrderNo],[Status],[DeleteFlag],[Show]) 
					VALUES(S.ProductLine_Code,0,S.ProductLine_Name,1,'','',0,1);
  
				--导入PDT
				MERGE Sol_DataIDSetTest  AS T
				USING (SELECT pro.PDT_Code,pro.PDT_Name,pro.ProductLine_Code FROM Sol_ProductInfoTest pro GROUP BY pro.PDT_Code,pro.PDT_Name,pro.ProductLine_Code)  AS S
				ON T.SrcID=S.PDT_Code
				WHEN MATCHED THEN 
					UPDATE SET T.SrcName=S.PDT_Name,T.SrcPID=S.ProductLine_Code
				WHEN NOT MATCHED THEN 
					INSERT ([SrcID],[SrcPID],[SrcName],[IDLevel],[OrderNo],[Status],[DeleteFlag],[Show]) 
					VALUES(S.PDT_Code,S.ProductLine_Code,S.PDT_Name,2,'','',0,1);

				--导入R版本
				MERGE Sol_DataIDSetTest  AS T
				USING (SELECT pro.Release_Code,pro.Release_Name,pro.PDT_Code FROM Sol_ProductInfoTest pro GROUP BY pro.Release_Code,pro.Release_Name,pro.PDT_Code)  AS S
				ON T.SrcID=S.Release_Code
				WHEN MATCHED THEN 
					UPDATE SET T.SrcName=S.Release_Name,T.SrcPID=S.PDT_Code
				WHEN NOT MATCHED THEN 
					INSERT ([SrcID],[SrcPID],[SrcName],[IDLevel],[OrderNo],[Status],[DeleteFlag],[Show]) 
					VALUES(S.Release_Code,S.PDT_Code,S.Release_Name,3,'','',0,1);

				--导入B版本
				MERGE Sol_DataIDSetTest  AS T
				USING (SELECT pro.B_Code,pro.B_Name,pro.Release_Code FROM Sol_ProductInfoTest pro GROUP BY pro.B_Code,pro.B_Name,pro.Release_Code)  AS S
				ON T.SrcID=S.B_Code
				WHEN MATCHED THEN 
					UPDATE SET T.SrcName=S.B_Name,T.SrcPID=S.Release_Code
				WHEN NOT MATCHED THEN 
					INSERT ([SrcID],[SrcPID],[SrcName],[IDLevel],[OrderNo],[Status],[DeleteFlag],[Show]) 
					VALUES(S.B_Code,S.Release_Code,S.B_Name,4,'','',0,1);

				--导入D版本
				MERGE Sol_DataIDSetTest  AS T
				USING (SELECT pro.D_Code,pro.D_Name,pro.B_Code FROM Sol_ProductInfoTest pro GROUP BY pro.D_Code,pro.D_Name,pro.B_Code)  AS S
				ON T.SrcID=S.D_Code
				WHEN MATCHED THEN 
					UPDATE SET T.SrcName=S.D_Name,T.SrcPID=S.B_Code
				WHEN NOT MATCHED THEN 
					INSERT ([SrcID],[SrcPID],[SrcName],[IDLevel],[OrderNo],[Status],[DeleteFlag],[Show]) 
					VALUES(S.D_Code,S.B_Code,S.D_Name,5,'','',0,1);

				--同步角色  插入STD经理
				insert into  Sol_PermissionTest
				(UserType,UserName,DataSetID,RCode,CreateBy,CreateTime,Modifier,ModifyTime)
				select  1 as userType,SUBSTRING(b.STDMgr,CHARINDEX(' ',b.STDMgr)+1,10),a.DataSetID,55,'',GETDATE(),null,null  from  Sol_DataIDSetTest  a  
				inner join Sol_ProductInfoTest b on  a.SrcID=b.D_Code

				--同步角色  插入STDArch
				insert into  Sol_PermissionTest
				(UserType,UserName,DataSetID,RCode,CreateBy,CreateTime,Modifier,ModifyTime)
				select  1 as userType,SUBSTRING(b.STDArch,CHARINDEX(' ',b.STDArch)+1,10),a.DataSetID,56,'',GETDATE(),null,null  from  Sol_DataIDSetTest  a  
				inner join Sol_ProductInfoTest b on  a.SrcID=b.D_Code

				--同步角色  插入二级部门主管
				insert into  Sol_PermissionTest
				(UserType,UserName,DataSetID,RCode,CreateBy,CreateTime,Modifier,ModifyTime)
				select  1 as userType,SUBSTRING(b.SecondDeptMgr,CHARINDEX(' ',b.SecondDeptMgr)+1,10),a.DataSetID,57,'',GETDATE(),null,null  from  Sol_DataIDSetTest  a  
				inner join Sol_ProductInfoTest b on  a.SrcID=b.D_Code

				--同步角色  插入三级部门主管
				insert into  Sol_PermissionTest
				(UserType,UserName,DataSetID,RCode,CreateBy,CreateTime,Modifier,ModifyTime)
				select  1 as userType,SUBSTRING(b.ThirdDeptMgr,CHARINDEX(' ',b.ThirdDeptMgr)+1,10),a.DataSetID,58,'',GETDATE(),null,null  from  Sol_DataIDSetTest  a  
				inner join Sol_ProductInfoTest b on  a.SrcID=b.D_Code

				--同步角色  STDArch默认规格责任人
				insert into  Sol_PermissionTest
				(UserType,UserName,DataSetID,RCode,CreateBy,CreateTime,Modifier,ModifyTime)
				select  1 as userType,SUBSTRING(b.STDArch,CHARINDEX(' ',b.STDArch)+1,10),a.DataSetID,1,'',GETDATE(),null,null  from  Sol_DataIDSetTest  a  
				inner join Sol_ProductInfoTest b on  a.SrcID=b.D_Code
		
				--删除临时表
				drop table #solProductInfo;
			commit transaction
		end try
		begin catch
			if	xact_state()=-1
				begin
					rollback transaction
				end
		end catch
	end
