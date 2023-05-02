USE [master]
GO

/****** Object:  LinkedServer [PMD_HRCP]    Script Date: 2019/10/13 11:02:21 ******/
EXEC master.dbo.sp_dropserver @server=N'PMD_HRCP', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [PMD_HRCP]    Script Date: 2019/10/13 11:02:21 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'PMD_HRCP', @srvproduct=N'', @provider=N'OraOLEDB.Oracle', @datasrc=N'PLMDB_143'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'PMD_HRCP',@useself=N'False',@locallogin=NULL,@rmtuser=N'infodba',@rmtpassword='########'

GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PMD_HRCP', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


