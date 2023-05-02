USE [iSEDB]
GO

/****** Object:  LinkedServer [iSplan]    Script Date: 2020/7/31 15:11:42 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'iSplan', @srvproduct=N'', @provider=N'SQLNCLI', @datasrc=N'10.90.12.115'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'iSplan',@useself=N'False',@locallogin=NULL,@rmtuser=N'isplan_productline',@rmtpassword='HelloWorld123'

GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplan', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


