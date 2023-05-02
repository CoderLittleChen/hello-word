-------------------------------------SPMS---------------------------------------------------
--SPMS  查询语句  链接   数据库链接串      生产环境  账号申请 找张洁      rpa  rpa_123
--测试环境的地址和视图的名称   
--select lineid,req_type,usertype  from   ViewName   where crm_no=’’
--gbts1 =
--         (DESCRIPTION =
--                   (ADDRESS = (PROTOCOL = TCP)(HOST = 10.165.8.84)(PORT = 1529))
--                   (CONNECT_DATA =
--                            (SERVER = DEDICATED)
--                            (SERVICE_NAME = gbts1)
--                   )
--         )  
--httsp://spms.h3c.com/spms/require/applicationDetails.do?req_requirement_line_id=757082&req_type=2&usertype=0
--select * from spms.view_application_rma 

--------------------------------------------RTS--------------------------------------------
--RTS   查询语句  链接   数据库链接串   账号u001   u001      
--select * from t_Mt_Task_Barcode where Barcode=''    需要明确任务令是哪个字段
--(DESCRIPTION =
--   (ADDRESS_LIST =
--     (ADDRESS = (PROTOCOL = TCP)(HOST = 10.165.8.84)(PORT = 1532))
--   )
--   (CONNECT_DATA =
--     (SERVER = DEDICATED)
--     (SERVICE_NAME = ora2cs1)
--   )
-- )

---------------------------------------数据库链接字符串----------------------------------------
 --"Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=10.165.8.84)(PORT=1529))(CONNECT_DATA=(SERVICE_NAME=gbts1)));User Id=rpa;Password=rpa_123"
 --SPMS
 --Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=10.165.8.84)(PORT=1529))(CONNECT_DATA=(SERVICE_NAME=gbts1)));User Id=rpa;Password=rpa_123
 --RTS
 --Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=10.165.8.84)(PORT=1532))(CONNECT_DATA=(SERVICE_NAME=ora2cs1)));User Id=u001;Password=u001



 select   *   from   ProjectPersonInfo   a;

 select   *   from   PrjectPersonRDODC  a;