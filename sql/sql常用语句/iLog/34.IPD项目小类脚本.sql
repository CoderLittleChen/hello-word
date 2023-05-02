USE [PersonalInput]
GO
/****** Object:  Table [dbo].[IPDProjectSubType]    Script Date: 2020/2/25 14:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IPDProjectSubType](
	[IPDProjectSubTypeID] [uniqueidentifier] NOT NULL,
	[IPDProjectTypeID] [uniqueidentifier] NULL,
	[Name] [nvarchar](80) NULL,
	[Code] [nvarchar](50) NULL,
	[DisplayOrder] [nvarchar](5) NULL,
	[Description] [nvarchar](200) NULL,
	[CreationDate] [datetime] NULL DEFAULT (getdate()),
	[Creator] [nvarchar](50) NULL,
	[ModificationDate] [datetime] NULL DEFAULT (getdate()),
	[Modifier] [nvarchar](50) NULL,
	[DeleteFlag] [int] NULL DEFAULT ((0)),
 CONSTRAINT [PK_IPDPROJECTSUBTYPE] PRIMARY KEY CLUSTERED 
(
	[IPDProjectSubTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'd1e68195-a4d0-4004-9937-0cbf0d51bd3f', N'4eddef39-04a8-4ee7-8c41-a74a800a3d43', N'解决方案B类', N'00303', N'315', N'解决方案B类', CAST(N'2013-11-02 20:23:11.080' AS DateTime), N'sysadmin', CAST(N'2013-11-02 20:23:11.080' AS DateTime), N'sysadmin', 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'01248680-5e79-49aa-abed-116bf7bee56a', N'39745539-fec0-48d4-b34c-0993c6f58008', N'OEM IN项目', N'00101', N'101', N'OEM IN项目(OEM IN项目)', CAST(N'2018-06-23 10:22:32.837' AS DateTime), N'sysadmin', NULL, NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'6b195e5c-1867-45d0-8922-193ffac333da', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'服务器ODM OUT项目', N'00109', N'109', N'IPD产品开发项目（服务器ODM OUT项目）', CAST(N'2015-10-26 10:45:44.197' AS DateTime), N'liufeng 10033', CAST(N'2015-10-26 10:45:44.200' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'89c22efa-3a4f-4d5e-8cdf-1bda34dc7616', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'纯硬件项目', N'00103', N'103', N'IPD产品开发项目（纯硬件项目）', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'e4539da9-96c3-4f1f-9256-1d701acc0017', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'OEM OUT项目', N'00114', N'114', N'IPD产品开发项目（OEM OUT项目）', CAST(N'2018-01-03 14:42:49.100' AS DateTime), N'sysadmin', CAST(N'2018-01-03 14:42:49.100' AS DateTime), N'sysadmin', 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'eeacc46d-3d46-4670-9f82-2a515a4dcc47', N'240341c3-e690-4f3f-81d2-331adc337845', N'软件平台', N'00501', N'501', N'产品生命周期项目', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'210091c3-6e17-49b6-b754-312399c1dc72', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'综合产品软件项目', N'00107', N'107', N'IPD产品开发项目（综合产品软件项目）', CAST(N'2015-03-17 14:40:21.857' AS DateTime), N'liufeng 10033', CAST(N'2015-03-17 14:40:21.857' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'c401c795-b884-4544-a9f4-31989d76c2f1', N'3beec9cc-c4ae-43a1-aae5-4ad8beac2fb6', N'技术开发项目4类', N'00405', N'405', N'技术开发项目4类', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, -1)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'db760b5a-ad66-4770-8580-455043de6904', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'OEM IN项目', N'00113', N'113', N'IPD产品开发项目（OEM IN项目）', CAST(N'2018-01-03 14:42:49.097' AS DateTime), N'sysadmin', CAST(N'2018-01-03 14:42:49.097' AS DateTime), N'sysadmin', 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'e6b121d6-9b2a-4813-8adc-4a871840b74e', N'3beec9cc-c4ae-43a1-aae5-4ad8beac2fb6', N'预研项目', N'00401', N'401', N'预研项目', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'bb85bb5a-3807-476c-a6f4-5ef2171837c9', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'纯软件项目', N'00102', N'102', N'IPD产品开发项目（纯软件项目）', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'b78a356a-2984-4370-ae8f-6112876146d2', N'98d4b9d3-c5d1-4826-8b5b-d2db1fd5a837', N'服务器ODM IN项目', N'00102', N'102', N'ODM IN项目（服务器ODM IN项目）', CAST(N'2019-09-28 11:03:31.920' AS DateTime), N'', CAST(N'2019-09-28 11:03:31.920' AS DateTime), N'', 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'7d34c4a8-b382-4d8a-a154-6ff868eb5809', N'98d4b9d3-c5d1-4826-8b5b-d2db1fd5a837', N'ODM IN项目', N'00101', N'101', N'ODM IN项目（ODM IN项目）', CAST(N'2019-01-16 11:15:36.567' AS DateTime), N'sysadmin', CAST(N'2019-01-16 11:15:36.567' AS DateTime), N'admin', 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'18a156ea-daef-47d7-8bd2-710e5f583f36', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'消费类项目', N'00112', N'112', N'IPD产品开发项目（消费类项目）', CAST(N'2017-06-29 09:26:36.190' AS DateTime), N'songdongmei KF2525', CAST(N'2017-06-29 09:26:36.190' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'e2dc55dc-3b8d-44d8-b364-85f7f60cc823', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'光模块项目', N'00106', N'106', N'IPD产品开发项目（光模块项目）', CAST(N'2013-10-30 09:12:07.857' AS DateTime), N'sysadmin', CAST(N'2013-10-30 09:12:07.857' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'46502dc8-4764-45fc-b135-95fd5640d6cc', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'服务器基础组件项目', N'00115', N'115', N'IPD产品开发项目（服务器基础组件项目）', CAST(N'2018-12-05 17:33:23.493' AS DateTime), N'sysadmin', NULL, NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'fb9971f7-79b3-4f0b-b680-9875204a2f00', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'服务器自研项目', N'00108', N'108', N'IPD产品开发项目（服务器自研项目）', CAST(N'2015-10-26 10:45:44.197' AS DateTime), N'liufeng 10033', CAST(N'2015-10-26 10:45:44.197' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'794e4ecb-1360-46bf-a995-a2e6e2d46aa5', N'3beec9cc-c4ae-43a1-aae5-4ad8beac2fb6', N'技术开发项目1类', N'00402', N'402', N'技术开发项目1类', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, -1)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'9ddb7435-4ae7-4ede-9518-b006beccb04a', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'ODM IN项目', N'00111', N'111', N'IPD产品开发项目（ODM IN项目）', CAST(N'2017-04-07 09:30:43.057' AS DateTime), N'songdongmei KF2525', CAST(N'2017-04-07 09:30:43.057' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'f0aec8f3-9a46-4840-90ca-b6a4dab4fade', N'cad2777d-c78d-4ebe-bc21-f0c20fe8a814', N'DevOps（软件非HP无网管）', N'00101', N'101', N'DevOps（软件非HP无网管）', CAST(N'2018-08-18 10:09:00.367' AS DateTime), N'sysadmin', NULL, NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'5ac9f503-9718-49b6-9dcf-b95f8a55d503', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'服务器ODM IN项目', N'00110', N'110', N'IPD产品开发项目（服务器ODM IN项目）', CAST(N'2017-04-05 16:38:07.120' AS DateTime), N'songdongmei KF2525', CAST(N'2017-04-05 16:38:07.120' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'ef52471a-ccfe-40bf-a498-c0ce53d2cf29', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'SMB项目', N'00105', N'105', N'IPD产品开发项目（SMB项目）', CAST(N'2012-11-21 14:34:40.547' AS DateTime), N'sysadmin', CAST(N'2012-11-21 14:34:40.547' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'6dda0422-3854-49c2-8491-c3dc48d85a89', N'4eddef39-04a8-4ee7-8c41-a74a800a3d43', N'解决方案A类', N'00302', N'310', N'解决方案A类', CAST(N'2013-11-02 20:23:11.070' AS DateTime), N'sysadmin', CAST(N'2013-11-02 20:23:11.070' AS DateTime), N'sysadmin', 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'35400ec0-a5fe-46bb-9cc0-c5870a3bf091', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'正常IPD项目', N'00101', N'101', N'IPD产品开发项目（正常IPD项目）', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'36e4d91a-b1d2-421a-a68e-d4e05980b375', N'3beec9cc-c4ae-43a1-aae5-4ad8beac2fb6', N'技术开发项目3类', N'00404', N'404', N'技术开发项目3类', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, -1)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'a511e1fa-68b6-4048-a5cf-d6925f03f849', N'b439b0ab-68eb-47c9-aa1e-0a5f230c9bdb', N'OEM OUT项目', N'00202', N'202', N'大客户合作项目（OEM OUT项目）', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'efdde7b0-85f6-40ed-8aa2-d7da86cac69a', N'5e50d98c-45d5-4972-8eb8-912e6f47b224', N'包装项目', N'00104', N'104', N'IPD产品开发项目（包装项目）', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'3842309a-b429-43e1-be3a-d9542f0abded', N'240341c3-e690-4f3f-81d2-331adc337845', N'硬件平台', N'00502', N'502', N'硬件平台', CAST(N'2012-01-04 00:00:00.000' AS DateTime), NULL, CAST(N'2012-01-04 14:20:14.507' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'caa8fb7a-a239-4581-a182-d9e3560da31a', N'3beec9cc-c4ae-43a1-aae5-4ad8beac2fb6', N'技术开发项目', N'00406', N'406', N'技术开发项目', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'ed9f411d-061d-4b37-b30c-e150488ccb7f', N'b439b0ab-68eb-47c9-aa1e-0a5f230c9bdb', N'OEM IN项目', N'00201', N'201', N'大客户合作项目（OEM IN项目）', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, 0)
GO
INSERT [dbo].[IPDProjectSubType] ([IPDProjectSubTypeID], [IPDProjectTypeID], [Name], [Code], [DisplayOrder], [Description], [CreationDate], [Creator], [ModificationDate], [Modifier], [DeleteFlag]) VALUES (N'4149164f-5ddb-4ffb-a16c-f850164f4db1', N'3beec9cc-c4ae-43a1-aae5-4ad8beac2fb6', N'技术开发项目2类', N'00403', N'403', N'技术开发项目2类', CAST(N'2011-07-29 11:38:30.360' AS DateTime), N'sysadmin', CAST(N'2011-07-29 11:38:30.360' AS DateTime), NULL, -1)
GO
ALTER TABLE [dbo].[IPDProjectSubType]  WITH CHECK ADD  CONSTRAINT [FK_FoundationData_03] FOREIGN KEY([IPDProjectTypeID])
REFERENCES [dbo].[IPDProjectType] ([IPDProjectTypeID])
GO
ALTER TABLE [dbo].[IPDProjectSubType] CHECK CONSTRAINT [FK_FoundationData_03]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'IPDProjectSubTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'IPDProjectTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'显示顺序' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'DisplayOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'CreationDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建者' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'Creator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'更新日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'ModificationDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'更新者' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'Modifier'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'删除标识：-1——已删除；0——未删除' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IPDProjectSubType', @level2type=N'COLUMN',@level2name=N'DeleteFlag'
GO
