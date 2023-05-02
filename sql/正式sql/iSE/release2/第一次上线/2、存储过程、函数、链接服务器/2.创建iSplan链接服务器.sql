USE [iSEDB]
GO

/****** Object:  LinkedServer [iSplan]    Script Date: 2021/1/21 13:53:45 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'iSplanFormal', @srvproduct=N'', @provider=N'SQLNCLI', @datasrc=N'hz-ctsdb-02'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'iSplanFormal',@useself=N'False',@locallogin=NULL,@rmtuser=N'iSE_ProductFrom_iSplan',@rmtpassword='CtsDb4iSeUser'

GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'iSplanFormal', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


