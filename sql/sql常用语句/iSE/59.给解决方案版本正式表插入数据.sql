----truncate  table  Sol_DataIDSet;
--insert  into   Sol_DataIDSet
--select  a.SrcID,a.SrcPID,a.SrcName,a.IDLevel,a.OrderNo,a.Status,a.DeleteFlag,a.Show
--from Sol_DataIDSetTemp  a;

insert  into Sol_ProductInfo
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
      ,[Solution_Code]
      ,[Solution_Name]
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
      ,[ThirdDeptMgr]
	  ,[Solution_Code]
      ,[Solution_Name]
  FROM [iSEDB].[dbo].[Sol_ProductInfoTemp]