--1、先删除中间表 Sol_ProductInfo表的数据  然后全部查询iSPlan视图插入,将数据插入中间表
--truncate table Sol_ProductInfo ;
--2、将中间表数据同步到 正式表 Sol_DataIDSet

select  *  from  Sol_ProductInfo   a;

select  *  from  Sol_DataIDSet  a ;

--create  procedure  P_UpdateSolProductInfo
--as
--	begin 
		
--	end