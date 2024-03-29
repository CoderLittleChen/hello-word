USE [iSEDB]
GO
SET IDENTITY_INSERT [dbo].[Sol_DataIDSet] ON 

GO
--INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (1, N'PL010000', N'0', N'云数产品线', 1, 0, 1, 0, 1)
--GO
--INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (2, N'PL020000', N'0', N'网络产品线', 1, 0, 1, 0, 1)
--GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (3, N'PT011000', N'PL010000', N'云数超融合解决方案', 2, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (4, N'PT022000', N'PL020000', N'AD-WAN广域网解决方案', 2, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (5, N'PR011100', N'PT011000', N'H3Cloud V700R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (6, N'PR022200', N'PT022000', N'AD-WANV200R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (7, N'PR022300', N'PT022000', N'AD-WANV200R002', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (8, N'PB011120', N'PR011100', N'H3Cloud V700R001B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (9, N'PB022240', N'PR022200', N'AD-WANV200R001B05', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (10, N'PB022260', N'PR022200', N'AD-WANV200R001B06', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (11, N'PB022280', N'PR022300', N'AD-WANV200R002B003', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (12, N'PD011122', N'PB011120', N'H3Cloud V700R001B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (13, N'PD022244', N'PB022240', N'AD-WANV200R001B05D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (14, N'PD022266', N'PB022260', N'AD-WANV200R001B06D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (15, N'PD022288', N'PB022280', N'AD-WANV200R002B003D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (16, N'PR003675', N'PT000281', N'医保信息化解决方案', 0, 0, 1, 0, 0)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (17, N'PL000021', N'0', N'无线产品线', 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (18, N'PL000022', N'0', N'智能管理与运维产品线', 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (19, N'PL000030', N'0', N'云与智能产品线', 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (20, N'PL000037', N'0', N'解决方案', 1, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (21, N'PT000204', N'PL000022', N'CloudNet解决方案 SPDT', 2, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (22, N'PT000258', N'PL000021', N'移动通信解决方案', 2, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (23, N'PT000262', N'PL000030', N'云计算解决方案 SPDT', 2, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (24, N'PT000281', N'PL000037', N'解决方案开发', 2, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (25, N'PR001645', N'PT000204', N'IPTV V100R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (26, N'PR001746', N'PT000204', N'MEN V100R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (27, N'PR001753', N'PT000204', N'IPTelephony V100R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (28, N'PR001785', N'PT000204', N'IDC V100R003', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (29, N'PR002012', N'PT000281', N'H3C解决方案公共', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (30, N'PR002095', N'PT000204', N'IVS V100R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (31, N'PR003022', N'PT000258', N'LTE OEM V100R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (32, N'PR003049', N'PT000258', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (33, N'PR003156', N'PT000258', N'UE V200R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (34, N'PR003182', N'PT000281', N'解决方案规划公共', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (35, N'PR003192', N'PT000262', N'H3Cloud V600R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (36, N'PR003206', N'PT000281', N'数字化和智慧类解决方案', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (37, N'PR003419', N'PT000281', N'DNEC V100R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (38, N'PR003420', N'PT000281', N'DNDC V200R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (39, N'PR003685', N'PT000258', N'移动通信维护开发项目', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (40, N'VB20181205095826278', N'PR003420', N'201812_PDCP_RB01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (41, N'VB20181207094508096', N'PR003420', N'201812_PDCP_RB02', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (42, N'VB20190905171232817', N'PR003420', N'201812_PDCP_RB10', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (43, N'VB20190905173240770', N'PR003420', N'201812_PDCP_RB16', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (44, N'VB20190909110614014', N'PR003420', N'201812_PDCP_RB19', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (45, N'VB20191128145126609', N'PR002095', N'极客强人挑战赛B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (46, N'VB20191128162734593', N'PR003206', N'areB01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (47, N'VB20191128164959074', N'PR003206', N'areB02', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (48, N'VB20200309145222892', N'PR003182', N'移动审批 V1001B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (49, N'VB20200310164225128', N'PR003182', N'移动审批 V1001B02', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (50, N'VB20200311162816618', N'PR003182', N'移动审批 V1001B03', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (51, N'VB20200311164633855', N'PR003182', N'移动审批 V1001B04', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (52, N'VB20200311165634542', N'PR003182', N'移动审批 V1001B05', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (53, N'VB20200311170825494', N'PR003182', N'移动审批 V1001B06', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (54, N'VB20200311172610384', N'PR003182', N'移动审批 V1001B07', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (55, N'VB20200312160551009', N'PR003182', N'移动审批 V1001B08', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (56, N'VB20200312161145102', N'PR003182', N'移动审批 V1001B09', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (57, N'VB20200312161923930', N'PR003182', N'移动审批 V1001B10', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (58, N'VB20200312162130898', N'PR003182', N'移动审批 V1001B11', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (59, N'VB20200312163238523', N'PR003182', N'移动审批 V1001B12', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (60, N'VB20200312170010771', N'PR003182', N'非移动,不审批B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (61, N'VB20200316151317614', N'PR002012', N'sowhatB01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (62, N'VB20200316163132085', N'PR003182', N'移动审批 V1001B13', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (63, N'VB20200317142330398', N'PR003182', N'非移动,不审批B02', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (64, N'VB20200317142349257', N'PR003182', N'非移动,不审批B03', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (65, N'VB20200317142416992', N'PR003182', N'非移动,不审批B05', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (66, N'VB20200318150908814', N'PR003182', N'移动审批 V1001B14', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (67, N'VB20200319092617115', N'PR003182', N'移动审批 V1001B15', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (68, N'VB20200320172006518', N'PR003182', N'移动审批 V1001B16', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (69, N'VB20200323094709488', N'PR003182', N'移动审批 V1001B17', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (70, N'VB20200323141633636', N'PR003182', N'移动审批 V1001B18', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (71, N'VB20200324100002530', N'PR003182', N'我的名字 V01B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (72, N'VB20200324111923226', N'PR003182', N'我的名字 V01B02', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (73, N'VB20200324152944720', N'PR003182', N'我的名字 V01B03', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (74, N'VB20200324153756625', N'PR003182', N'演示示例B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (75, N'VB20200324153810907', N'PR003182', N'演示示例B02', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (76, N'VB20200324153821610', N'PR003182', N'演示示例B03', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (77, N'VB20200326110547906', N'PR003182', N'我的名字 V01B04', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (78, N'VB20200327141305557', N'PR003182', N'我的名字 V01B05', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (79, N'VB20200330104441135', N'PR003182', N'技术委员会主任审批模拟B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (80, N'VB20200331093456515', N'PR003182', N'红牛云基地搭建项目B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (81, N'VB20200331102225417', N'PR002095', N'极客强人挑战赛B03', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (82, N'VB20200331143601864', N'PR003182', N'我的名字 V01B06', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (83, N'VB20200331144249472', N'PR002012', N'多待办问题B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (84, N'VB20200331150411346', N'PR003182', N'我的名字 V01B07', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (85, N'VB20200331153804014', N'PR003182', N'红牛云基地搭建项目B02', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (86, N'VB20200331153820592', N'PR003182', N'红牛云基地搭建项目B03', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (87, N'VB20200331212518946', N'PR003182', N'我的名字 V01B08', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (88, N'VB20200331220206833', N'PR003182', N'我的名字 V01B09', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (89, N'VB20200331222823034', N'PR003182', N'我的名字 V01B10', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (90, N'VB20200401091213924', N'PR003182', N'红牛云基地搭建项目B04', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (91, N'VB20200401091226439', N'PR003182', N'红牛云基地搭建项目B05', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (92, N'VB20200401113228073', N'PR003182', N'我的名字 V01B11', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (93, N'VB20200401132001362', N'PR003182', N'我的名字 V01B12', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (94, N'VB20200401160036689', N'PR003182', N'红牛云基地搭建项目B06', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (95, N'VB20200401162342905', N'PR003182', N'红牛云基地搭建项目B07', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (96, N'VB20200401162353890', N'PR003182', N'红牛云基地搭建项目B08', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (97, N'VB20200402145645183', N'PR003182', N'红牛云基地搭建项目B10', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (98, N'VB20200402162128207', N'PR003182', N'红牛云基地搭建项目B09', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (99, N'VB20200403161106316', N'PR003182', N'测试B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (100, N'VB20200403161331206', N'PR002095', N'极客强人挑战赛B04', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (101, N'VB20200423154929679', N'PR003675', N'驳回的流程B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (102, N'VB20200423160100052', N'PR003675', N'驳回的流程B02', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (103, N'VB20200507134839955', N'PR003182', N'演示示例B04', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (104, N'VB20200507134849861', N'PR003182', N'演示示例B05', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (105, N'VB20200507134901424', N'PR003182', N'演示示例B06', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (106, N'VB20200507134913674', N'PR003182', N'演示示例B07', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (107, N'VB20200509141556502', N'PR003182', N'演示示例B08', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (108, N'VB20200509141612127', N'PR003182', N'演示示例B09', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (109, N'VB20200509141629096', N'PR003182', N'演示示例B10', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (110, N'VB20200509145757014', N'PR003419', N'整体流程测试 V100R001B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (111, N'VB20200509151049920', N'PR003675', N'整体流程测试 V100R003B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (112, N'VB20200509152258684', N'PR003675', N' V100R04B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (113, N'VB20200509154258980', N'PR003419', N' V100R001B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (114, N'VB20200509154708557', N'PR003182', N' V100R002B02', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (115, N'VB20200511163901785', N'PR003182', N'解决方案规划公共B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (116, N'VB20200512091943853', N'PR003182', N'红牛云基地搭建项目B20', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (117, N'VB20200512092003040', N'PR003182', N'红牛云基地搭建项目B21', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (118, N'VB20200512092017509', N'PR003182', N'红牛云基地搭建项目B22', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (119, N'VB20200514150411037', N'PR003675', N'医保信息化解决方案B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (120, N'VB20200514152914549', N'PR002095', N'极客强人挑战赛B10', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (121, N'VB20200516175850227', N'PR003156', N'UE V200R001B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (122, N'VB20200517152055719', N'PR001753', N'IPTelephony V100R001B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (123, N'VB20200519151329036', N'PR003685', N'移动通信维护开发项目B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (124, N'VB20200520093133637', N'PR001785', N'IDC V100R003B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (125, N'VB20200520105301754', N'PR001746', N'MEN V100R001B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (126, N'VB20200526152623569', N'PR001645', N'IPTV V100R001B10', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (127, N'VB20200528162420059', N'PR003049', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B01', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (128, N'VB20200710102308729', N'PR003192', N'H3Cloud V600R001B06', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (129, N'VB20200722150535269', N'PR003022', N'LTE OEM V100R001B06', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (130, N'VB20200727134507109', N'PR003022', N'LTE OEM V100R001B16', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (131, N'VB20200729170957978', N'PR003049', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B16', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (132, N'VB20200803152505526', N'PR003049', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B11', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (133, N'VD20181205095837793', N'VB20181205095826278', N'201812_PDCP_RB01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (134, N'VD20181207094527877', N'VB20181207094508096', N'201812_PDCP_RB02D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (135, N'VD20190905171351270', N'VB20190905171232817', N'201812_PDCP_RB10D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (136, N'VD20190905173406348', N'VB20190905173240770', N'201812_PDCP_RB16D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (137, N'VD20190909114510577', N'VB20190909110614014', N'201812_PDCP_RB19D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (138, N'VD20191128145132969', N'VB20191128145126609', N'极客强人挑战赛B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (139, N'VD20191128162745995', N'VB20191128162734593', N'areB01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (140, N'VD20191128165003074', N'VB20191128164959074', N'areB02D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (141, N'VD20200309145226548', N'VB20200309145222892', N'移动审批 V1001B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (142, N'VD20200310164228972', N'VB20200310164225128', N'移动审批 V1001B02D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (143, N'VD20200311162820524', N'VB20200311162816618', N'移动审批 V1001B03D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (144, N'VD20200311164637496', N'VB20200311164633855', N'移动审批 V1001B04D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (145, N'VD20200311165638323', N'VB20200311165634542', N'移动审批 V1001B05D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (146, N'VD20200311170828963', N'VB20200311170825494', N'移动审批 V1001B06D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (147, N'VD20200311172614181', N'VB20200311172610384', N'移动审批 V1001B07D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (148, N'VD20200312160556509', N'VB20200312160551009', N'移动审批 V1001B08D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (149, N'VD20200312161149618', N'VB20200312161145102', N'移动审批 V1001B09D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (150, N'VD20200312161927523', N'VB20200312161923930', N'移动审批 V1001B10D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (151, N'VD20200312162134258', N'VB20200312162130898', N'移动审批 V1001B11D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (152, N'VD20200312163242866', N'VB20200312163238523', N'移动审批 V1001B12D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (153, N'VD20200312170015974', N'VB20200312170010771', N'非移动,不审批B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (154, N'VD20200316151324270', N'VB20200316151317614', N'sowhatB01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (155, N'VD20200316163135898', N'VB20200316163132085', N'移动审批 V1001B13D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (156, N'VD20200317142335492', N'VB20200317142330398', N'非移动,不审批B02D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (157, N'VD20200317142353648', N'VB20200317142349257', N'非移动,不审批B03D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (158, N'VD20200317142420960', N'VB20200317142416992', N'非移动,不审批B05D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (159, N'VD20200318150912876', N'VB20200318150908814', N'移动审批 V1001B14D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (160, N'VD20200319092622803', N'VB20200319092617115', N'移动审批 V1001B15D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (161, N'VD20200320172010143', N'VB20200320172006518', N'移动审批 V1001B16D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (162, N'VD20200323094713441', N'VB20200323094709488', N'移动审批 V1001B17D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (163, N'VD20200323141637307', N'VB20200323141633636', N'移动审批 V1001B18D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (164, N'VD20200324100007155', N'VB20200324100002530', N'我的名字 V01B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (165, N'VD20200324111927070', N'VB20200324111923226', N'我的名字 V01B02D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (166, N'VD20200324152948564', N'VB20200324152944720', N'我的名字 V01B03D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (167, N'VD20200324153800844', N'VB20200324153756625', N'演示示例B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (168, N'VD20200324153815860', N'VB20200324153810907', N'演示示例B02D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (169, N'VD20200324153826281', N'VB20200324153821610', N'演示示例B03D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (170, N'VD20200326110552312', N'VB20200326110547906', N'我的名字 V01B04D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (171, N'VD20200327141309119', N'VB20200327141305557', N'我的名字 V01B05D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (172, N'VD20200330104444885', N'VB20200330104441135', N'技术委员会主任审批模拟B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (173, N'VD20200331093500593', N'VB20200331093456515', N'红牛云基地搭建项目B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (174, N'VD20200331102230886', N'VB20200331102225417', N'极客强人挑战赛B03D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (175, N'VD20200331143605020', N'VB20200331143601864', N'我的名字 V01B06D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (176, N'VD20200331144252769', N'VB20200331144249472', N'多待办问题B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (177, N'VD20200331150414971', N'VB20200331150411346', N'我的名字 V01B07D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (178, N'VD20200331153809108', N'VB20200331153804014', N'红牛云基地搭建项目B02D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (179, N'VD20200331153824374', N'VB20200331153820592', N'红牛云基地搭建项目B03D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (180, N'VD20200331212522821', N'VB20200331212518946', N'我的名字 V01B08D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (181, N'VD20200331220210708', N'VB20200331220206833', N'我的名字 V01B09D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (182, N'VD20200331222827362', N'VB20200331222823034', N'我的名字 V01B10D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (183, N'VD20200401091219017', N'VB20200401091213924', N'红牛云基地搭建项目B04D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (184, N'VD20200401091308892', N'VB20200401091226439', N'红牛云基地搭建项目B05D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (185, N'VD20200401113232105', N'VB20200401113228073', N'我的名字 V01B11D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (186, N'VD20200401132005205', N'VB20200401132001362', N'我的名字 V01B12D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (187, N'VD20200401160041658', N'VB20200401160036689', N'红牛云基地搭建项目B06D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (188, N'VD20200401162347937', N'VB20200401162342905', N'红牛云基地搭建项目B07D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (189, N'VD20200401162358733', N'VB20200401162353890', N'红牛云基地搭建项目B08D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (190, N'VD20200402145650105', N'VB20200402145645183', N'红牛云基地搭建项目B10D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (191, N'VD20200402162132800', N'VB20200402162128207', N'红牛云基地搭建项目B09D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (192, N'VD20200403161109800', N'VB20200403161106316', N'测试B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (193, N'VD20200403161337503', N'VB20200403161331206', N'极客强人挑战赛B04D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (194, N'VD20200422145422187', N'VB20200403161331206', N'极客强人挑战赛B04D002', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (195, N'VD20200423154936475', N'VB20200423154929679', N'驳回的流程B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (196, N'VD20200423160104568', N'VB20200423160100052', N'驳回的流程B02D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (197, N'VD20200507134844299', N'VB20200507134839955', N'演示示例B04D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (198, N'VD20200507134855143', N'VB20200507134849861', N'演示示例B05D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (199, N'VD20200507134905627', N'VB20200507134901424', N'演示示例B06D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (200, N'VD20200507134917830', N'VB20200507134913674', N'演示示例B07D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (201, N'VD20200509141601784', N'VB20200509141556502', N'演示示例B08D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (202, N'VD20200509141620455', N'VB20200509141612127', N'演示示例B09D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (203, N'VD20200509141635533', N'VB20200509141629096', N'演示示例B10D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (204, N'VD20200509145800998', N'VB20200509145757014', N'整体流程测试 V100R001B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (205, N'VD20200509151053466', N'VB20200509151049920', N'整体流程测试 V100R003B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (206, N'VD20200509152302778', N'VB20200509152258684', N' V100R04B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (207, N'VD20200509154302198', N'VB20200509154258980', N' V100R001B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (208, N'VD20200509154712323', N'VB20200509154708557', N' V100R002B02D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (209, N'VD20200511164239204', N'VB20200511163901785', N'解决方案规划公共B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (210, N'VD20200512091951759', N'VB20200512091943853', N'红牛云基地搭建项目B20D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (211, N'VD20200512092009290', N'VB20200512092003040', N'红牛云基地搭建项目B21D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (212, N'VD20200512092023134', N'VB20200512092017509', N'红牛云基地搭建项目B22D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (213, N'VD20200514150419115', N'VB20200514150411037', N'医保信息化解决方案B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (214, N'VD20200514152920268', N'VB20200514152914549', N'极客强人挑战赛B10D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (215, N'VD20200516175944332', N'VB20200516175850227', N'UE V200R001B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (216, N'VD20200517152055735', N'VB20200517152055719', N'IPTelephony V100R001B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (217, N'VD20200519151329536', N'VB20200519151329036', N'移动通信维护开发项目B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (218, N'VD20200520093134293', N'VB20200520093133637', N'IDC V100R003B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (219, N'VD20200520105302332', N'VB20200520105301754', N'MEN V100R001B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (220, N'VD20200526152624194', N'VB20200526152623569', N'IPTV V100R001B10D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (221, N'VD20200528162420622', N'VB20200528162420059', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B01D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (222, N'VD20200710085215558', N'VB20200403161331206', N'极客强人挑战赛B04D20200710v001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (223, N'VD20200710102309338', N'VB20200710102308729', N'H3Cloud V600R001B06D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (224, N'VD20200710103856613', N'VB20200324153821610', N'演示示例B03D20200710v001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (225, N'VD20200713105244555', N'VB20200401162342905', N'红牛云基地搭建项目B07D20200713v001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (226, N'VD20200713143042128', N'VB20200403161331206', N'极客强人挑战赛B04D01', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (227, N'VD20200713153057545', N'VB20200312161923930', N'移动审批维护测试 V1001B10D008', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (228, N'VD20200713164501140', N'VB20200403161331206', N'极客强人挑战赛B04D010203', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (229, N'VD20200714095544699', N'VB20200403161331206', N'极客强人挑战赛B04D2020071409', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (230, N'VD20200714110521887', N'VB20200324152944720', N'我的名字维护测试 V01B03Ddraft001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (231, N'VD20200716135235803', N'VB20200519151329036', N'移动通信维护开发项目B01D0716', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (232, N'VD20200716135925379', N'VB20200519151329036', N'移动通信维护开发项目B01D0716002', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (233, N'VD20200716140833187', N'VB20200519151329036', N'移动通信维护开发项目B01D0716003', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (234, N'VD20200722150536004', N'VB20200722150535269', N'LTE OEM V100R001B06D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (235, N'VD20200727134507890', N'VB20200727134507109', N'LTE OEM V100R001B16D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (236, N'VD20200729111706142', N'VB20200323094709488', N'移动审批维护测试 V1001B17D要', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (237, N'VD20200729170958853', N'VB20200729170957978', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B16D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (238, N'VD20200803152506526', N'VB20200803152505526', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B11D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (239, N'PR001900', N'PT000204', N'CVS V100R001', 3, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (240, N'VB20200805163658884', N'PR001900', N'CVS V100R001B19', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (241, N'VD20200805163659821', N'VB20200805163658884', N'CVS V100R001B19D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (242, N'VB20200813101020282', N'PR003675', N'驳回的流程B16', 4, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (243, N'VD20200813101021204', N'VB20200813101020282', N'驳回的流程B16D001', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (244, N'VD20200817135630722', N'VB20200317142349257', N'非移动,不审批B03D130', 5, 0, 1, 0, 1)
GO
INSERT [dbo].[Sol_DataIDSet] ([DataSetID], [SrcID], [SrcPID], [SrcName], [IDLevel], [OrderNo], [Status], [DeleteFlag], [Show]) VALUES (245, N'VD20200818133735824', N'VB20200324111923226', N'我的名字维护测试 V01B02D006', 5, 0, 1, 0, 1)
GO
SET IDENTITY_INSERT [dbo].[Sol_DataIDSet] OFF
GO
SET IDENTITY_INSERT [dbo].[Sol_Permission] ON 

--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (6025, 1, N'KF6468', 12, N'1', N'ys2338', CAST(N'2020-08-14 16:18:53.000' AS DateTime), N'', NULL)
--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (8208, 1, N'KF6468', 234, N'1', N'00428', CAST(N'2020-08-18 13:38:35.000' AS DateTime), N'', NULL)
--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (13185, 1, N'KF7785', 15, N'1', N'04963', CAST(N'2020-08-27 16:35:42.000' AS DateTime), N'', NULL)
--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (13187, 1, N'KF6468', 13, N'52', N'00428', CAST(N'2020-08-27 17:25:55.000' AS DateTime), NULL, NULL)
--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15942, 1, N'00408', 13, N'30', N'00428', CAST(N'2020-09-01 13:32:14.000' AS DateTime), NULL, NULL)
--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15943, 1, N'00739', 13, N'30', N'00428', CAST(N'2020-09-01 13:36:41.000' AS DateTime), NULL, NULL)
--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15944, 1, N'05563', 13, N'30', N'00428', CAST(N'2020-09-01 13:49:54.000' AS DateTime), NULL, NULL)
--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15949, 1, N'00756', 13, N'30', N'00428', CAST(N'2020-09-01 16:40:43.000' AS DateTime), NULL, NULL)
--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15955, 1, N'-1', 13, N'30', N'00428', CAST(N'2020-09-01 17:57:46.000' AS DateTime), NULL, NULL)
--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15960, 1, N'00764', 13, N'30', N'00428', CAST(N'2020-09-01 18:13:43.000' AS DateTime), NULL, NULL)
--GO
--INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15961, 1, N'KF6468', 13, N'52', N'00428', CAST(N'2020-09-01 18:13:43.000' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15962, 1, N'09941', 133, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15963, 1, N'09941', 134, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15964, 1, N'20491', 135, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15965, 1, N'09775', 136, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15966, 1, N'YS2397', 137, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15967, 1, N'YS2397', 138, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15968, 1, N'YS2558', 139, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15969, 1, N'YS2558', 140, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15970, 1, N'YS2558', 141, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15971, 1, N'YS2558', 142, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15972, 1, N'YS2558', 143, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15973, 1, N'YS2558', 144, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15974, 1, N'YS2558', 145, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15975, 1, N'YS2558', 146, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15976, 1, N'YS2558', 147, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15977, 1, N'YS2558', 148, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15978, 1, N'YS2558', 149, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15979, 1, N'YS2558', 150, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15980, 1, N'YS2558', 151, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15981, 1, N'YS2558', 152, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15982, 1, N'YS2442', 153, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15983, 1, N'YS2397', 154, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15984, 1, N'YS2558', 155, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15985, 1, N'YS2442', 156, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15986, 1, N'YS2558', 157, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15987, 1, N'09941', 158, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15988, 1, N'YS2558', 159, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15989, 1, N'YS2558', 160, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15990, 1, N'YS2558', 161, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15991, 1, N'YS2558', 162, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15992, 1, N'YS2558', 163, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15993, 1, N'YS2558', 164, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15994, 1, N'YS2558', 165, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15995, 1, N'YS2558', 166, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15996, 1, N'YS2442', 167, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15997, 1, N'YS2442', 168, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15998, 1, N'YS2442', 169, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (15999, 1, N'YS2558', 170, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16000, 1, N'YS2558', 171, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16001, 1, N'YS2442', 172, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16002, 1, N'YS2442', 173, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16003, 1, N'YS2397', 174, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16004, 1, N'YS2442', 175, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16005, 1, N'YS2558', 176, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16006, 1, N'YS2558', 177, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16007, 1, N'YS2442', 178, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16008, 1, N'YS2558', 179, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16009, 1, N'YS2558', 180, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16010, 1, N'YS2558', 181, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16011, 1, N'YS2558', 182, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16012, 1, N'YS2558', 183, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16013, 1, N'YS2397', 184, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16014, 1, N'YS2558', 185, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16015, 1, N'YS2558', 186, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16016, 1, N'YS2397', 187, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16017, 1, N'YS2558', 188, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16018, 1, N'YS2397', 189, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16019, 1, N'09941', 190, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16020, 1, N'09941', 191, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16021, 1, N'YS2558', 192, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16022, 1, N'YS2442', 193, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16023, 1, N'YS2442', 194, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16024, 1, N'YS2442', 195, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16025, 1, N'YS2397', 196, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16026, 1, N'YS2442', 197, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16027, 1, N'YS2397', 198, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16028, 1, N'YS2397', 199, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16029, 1, N'YS2558', 200, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16030, 1, N'YS2558', 201, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16031, 1, N'YS2442', 202, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16032, 1, N'YS2442', 203, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16033, 1, N'YS2558', 204, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16034, 1, N'YS2558', 205, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16035, 1, N'YS2558', 206, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16036, 1, N'YS2558', 207, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16037, 1, N'YS2558', 208, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16038, 1, N'YS2442', 209, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16039, 1, N'YS2397', 210, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16040, 1, N'YS2442', 211, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16041, 1, N'YS2442', 212, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16042, 1, N'YS2442', 213, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16043, 1, N'YS2442', 214, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16044, 1, N'YS2558', 215, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16045, 1, N'YS2558', 216, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16046, 1, N'YS2442', 217, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16047, 1, N'YS2442', 218, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16048, 1, N'YS2442', 219, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16049, 1, N'YS2442', 220, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16050, 1, N'YS2442', 221, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16051, 1, N'YS2442', 222, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16052, 1, N'YS2397', 223, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16053, 1, N'YS2442', 224, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16054, 1, N'YS2558', 225, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16055, 1, N'YS2442', 226, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16056, 1, N'YS2558', 227, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16057, 1, N'YS2397', 228, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16058, 1, N'YS2442', 229, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16059, 1, N'YS2558', 230, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16060, 1, N'YS2397', 231, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16061, 1, N'YS2397', 232, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16062, 1, N'YS2442', 233, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16063, 1, N'YS2397', 234, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16064, 1, N'YS2442', 235, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16065, 1, N'YS2558', 236, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16066, 1, N'YS2558', 237, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16067, 1, N'YS2442', 238, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16068, 1, N'09941', 241, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16069, 1, N'YS2442', 243, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16070, 1, N'YS2558', 244, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16071, 1, N'YS2558', 245, N'55', N'', CAST(N'2020-09-02 02:00:03.827' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16072, 1, N'09941', 133, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16073, 1, N'09941', 134, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16074, 1, N'09775', 135, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16075, 1, N'20491', 136, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16076, 1, N'YS2397', 137, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16077, 1, N'YS2558', 138, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16078, 1, N'YS2558', 139, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16079, 1, N'YS2558', 140, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16080, 1, N'YS2558', 141, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16081, 1, N'YS2558', 142, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16082, 1, N'YS2558', 143, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16083, 1, N'YS2558', 144, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16084, 1, N'YS2558', 145, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16085, 1, N'YS2558', 146, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16086, 1, N'YS2558', 147, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16087, 1, N'YS2558', 148, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16088, 1, N'YS2558', 149, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16089, 1, N'YS2558', 150, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16090, 1, N'YS2558', 151, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16091, 1, N'YS2558', 152, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16092, 1, N'YS2442', 153, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16093, 1, N'YS2397', 154, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16094, 1, N'YS2558', 155, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16095, 1, N'YS2442', 156, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16096, 1, N'YS2442', 157, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16097, 1, N'09941', 158, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16098, 1, N'YS2558', 159, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16099, 1, N'YS2558', 160, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16100, 1, N'YS2558', 161, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16101, 1, N'YS2558', 162, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16102, 1, N'YS2558', 163, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16103, 1, N'YS2558', 164, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16104, 1, N'YS2558', 165, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16105, 1, N'YS2558', 166, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16106, 1, N'YS2442', 167, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16107, 1, N'YS2558', 168, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16108, 1, N'YS2442', 169, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16109, 1, N'YS2558', 170, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16110, 1, N'YS2558', 171, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16111, 1, N'YS2442', 172, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16112, 1, N'YS2442', 173, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16113, 1, N'YS2442', 174, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16114, 1, N'YS2558', 175, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16115, 1, N'YS2558', 176, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16116, 1, N'YS2558', 177, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16117, 1, N'YS2442', 178, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16118, 1, N'YS2442', 179, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16119, 1, N'YS2558', 180, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16120, 1, N'YS2558', 181, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16121, 1, N'YS2558', 182, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16122, 1, N'YS2442', 183, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16123, 1, N'YS2442', 184, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16124, 1, N'YS2558', 185, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16125, 1, N'YS2558', 186, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16126, 1, N'YS2442', 187, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16127, 1, N'YS2442', 188, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16128, 1, N'YS2558', 189, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16129, 1, N'YS2442', 190, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16130, 1, N'YS2442', 191, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16131, 1, N'YS2558', 192, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16132, 1, N'YS2442', 193, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16133, 1, N'YS2397', 194, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16134, 1, N'YS2442', 195, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16135, 1, N'YS2442', 196, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16136, 1, N'YS2442', 197, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16137, 1, N'YS2442', 198, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16138, 1, N'YS2442', 199, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16139, 1, N'YS2442', 200, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16140, 1, N'YS2397', 201, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16141, 1, N'YS2442', 202, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16142, 1, N'YS2442', 203, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16143, 1, N'YS2558', 204, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16144, 1, N'YS2558', 205, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16145, 1, N'YS2558', 206, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16146, 1, N'YS2558', 207, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16147, 1, N'YS2558', 208, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16148, 1, N'YS2442', 209, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16149, 1, N'YS2442', 210, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16150, 1, N'YS2442', 211, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16151, 1, N'YS2442', 212, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16152, 1, N'YS2442', 213, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16153, 1, N'YS2442', 214, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16154, 1, N'YS2558', 215, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16155, 1, N'YS2558', 216, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16156, 1, N'09941', 217, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16157, 1, N'YS2442', 218, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16158, 1, N'YS2442', 219, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16159, 1, N'YS2442', 220, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16160, 1, N'YS2442', 221, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16161, 1, N'YS2397', 222, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16162, 1, N'YS2397', 223, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16163, 1, N'YS2442', 224, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16164, 1, N'YS2442', 225, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16165, 1, N'09941', 226, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16166, 1, N'YS2558', 227, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16167, 1, N'YS2397', 228, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16168, 1, N'YS2442', 229, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16169, 1, N'YS2558', 230, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16170, 1, N'09941', 231, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16171, 1, N'YS2397', 232, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16172, 1, N'YS2397', 233, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16173, 1, N'YS2397', 234, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16174, 1, N'YS2442', 235, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16175, 1, N'YS2558', 236, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16176, 1, N'YS2442', 237, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16177, 1, N'YS2442', 238, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16178, 1, N'09941', 241, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16179, 1, N'YS2442', 243, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16180, 1, N'YS2442', 244, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16181, 1, N'YS2558', 245, N'56', N'', CAST(N'2020-09-02 02:00:03.840' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16182, 1, N'09941', 133, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16183, 1, N'09941', 134, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16184, 1, N'20491', 135, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16185, 1, N'YS2397', 136, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16186, 1, N'YS2397', 137, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16187, 1, N'YS2397', 138, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16188, 1, N'YS2558', 139, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16189, 1, N'YS2558', 140, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16190, 1, N'YS2558', 141, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16191, 1, N'YS2558', 142, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16192, 1, N'YS2558', 143, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16193, 1, N'YS2558', 144, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16194, 1, N'YS2558', 145, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16195, 1, N'YS2558', 146, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16196, 1, N'YS2558', 147, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16197, 1, N'YS2558', 148, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16198, 1, N'YS2558', 149, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16199, 1, N'YS2558', 150, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16200, 1, N'YS2558', 151, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16201, 1, N'YS2558', 152, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16202, 1, N'YS2442', 153, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16203, 1, N'YS2397', 154, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16204, 1, N'YS2558', 155, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16205, 1, N'YS2442', 156, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16206, 1, N'YS2442', 157, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16207, 1, N'09941', 158, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16208, 1, N'YS2558', 159, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16209, 1, N'YS2558', 160, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16210, 1, N'YS2558', 161, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16211, 1, N'YS2558', 162, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16212, 1, N'YS2558', 163, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16213, 1, N'YS2558', 164, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16214, 1, N'YS2558', 165, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16215, 1, N'YS2558', 166, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16216, 1, N'YS2442', 167, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16217, 1, N'YS2442', 168, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16218, 1, N'YS2442', 169, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16219, 1, N'YS2558', 170, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16220, 1, N'YS2558', 171, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16221, 1, N'YS2442', 172, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16222, 1, N'YS2442', 173, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16223, 1, N'YS2397', 174, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16224, 1, N'YS2558', 175, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16225, 1, N'YS2558', 176, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16226, 1, N'YS2558', 177, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16227, 1, N'YS2442', 178, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16228, 1, N'YS2442', 179, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16229, 1, N'YS2558', 180, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16230, 1, N'YS2558', 181, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16231, 1, N'YS2558', 182, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16232, 1, N'YS2442', 183, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16233, 1, N'YS2442', 184, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16234, 1, N'YS2558', 185, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16235, 1, N'YS2558', 186, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16236, 1, N'YS2442', 187, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16237, 1, N'YS2442', 188, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16238, 1, N'YS2442', 189, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16239, 1, N'09941', 190, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16240, 1, N'09941', 191, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16241, 1, N'YS2558', 192, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16242, 1, N'YS2442', 193, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16243, 1, N'YS2397', 194, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16244, 1, N'YS2442', 195, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16245, 1, N'YS2442', 196, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16246, 1, N'YS2442', 197, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16247, 1, N'YS2442', 198, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16248, 1, N'YS2442', 199, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16249, 1, N'YS2558', 200, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16250, 1, N'YS2442', 201, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16251, 1, N'YS2442', 202, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16252, 1, N'YS2442', 203, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16253, 1, N'YS2558', 204, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16254, 1, N'YS2558', 205, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16255, 1, N'YS2558', 206, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16256, 1, N'YS2558', 207, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16257, 1, N'YS2558', 208, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16258, 1, N'YS2442', 209, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16259, 1, N'YS2442', 210, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16260, 1, N'YS2442', 211, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16261, 1, N'YS2442', 212, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16262, 1, N'YS2442', 213, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16263, 1, N'YS2442', 214, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16264, 1, N'YS2558', 215, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16265, 1, N'YS2558', 216, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16266, 1, N'09941', 217, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16267, 1, N'YS2442', 218, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16268, 1, N'YS2442', 219, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16269, 1, N'YS2442', 220, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16270, 1, N'YS2442', 221, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16271, 1, N'YS2397', 222, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16272, 1, N'YS2397', 223, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16273, 1, N'YS2442', 224, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16274, 1, N'YS2442', 225, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16275, 1, N'09941', 226, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16276, 1, N'YS2558', 227, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16277, 1, N'YS2397', 228, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16278, 1, N'YS2442', 229, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16279, 1, N'YS2558', 230, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16280, 1, N'09941', 231, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16281, 1, N'09941', 232, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16282, 1, N'YS2397', 233, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16283, 1, N'YS2397', 234, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16284, 1, N'YS2442', 235, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16285, 1, N'YS2558', 236, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16286, 1, N'YS2442', 237, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16287, 1, N'YS2442', 238, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16288, 1, N'09941', 241, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16289, 1, N'YS2442', 243, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16290, 1, N'YS2442', 244, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16291, 1, N'YS2558', 245, N'57', N'', CAST(N'2020-09-02 02:00:03.847' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16292, 1, N'09941', 133, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16293, 1, N'09941', 134, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16294, 1, N'20491', 135, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16295, 1, N'YS2397', 136, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16296, 1, N'YS2397', 137, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16297, 1, N'YS2397', 138, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16298, 1, N'YS2558', 139, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16299, 1, N'YS2558', 140, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16300, 1, N'YS2558', 141, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16301, 1, N'YS2558', 142, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16302, 1, N'YS2558', 143, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16303, 1, N'YS2558', 144, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16304, 1, N'YS2558', 145, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16305, 1, N'YS2558', 146, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16306, 1, N'YS2558', 147, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16307, 1, N'YS2558', 148, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16308, 1, N'YS2558', 149, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16309, 1, N'YS2558', 150, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16310, 1, N'YS2558', 151, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16311, 1, N'YS2558', 152, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16312, 1, N'YS2442', 153, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16313, 1, N'YS2397', 154, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16314, 1, N'YS2558', 155, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16315, 1, N'YS2442', 156, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16316, 1, N'YS2442', 157, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16317, 1, N'09941', 158, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16318, 1, N'YS2558', 159, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16319, 1, N'YS2558', 160, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16320, 1, N'YS2558', 161, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16321, 1, N'YS2558', 162, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16322, 1, N'YS2558', 163, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16323, 1, N'YS2558', 164, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16324, 1, N'YS2558', 165, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16325, 1, N'YS2558', 166, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16326, 1, N'YS2442', 167, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16327, 1, N'YS2442', 168, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16328, 1, N'YS2442', 169, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16329, 1, N'YS2558', 170, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16330, 1, N'YS2558', 171, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16331, 1, N'YS2442', 172, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16332, 1, N'YS2442', 173, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16333, 1, N'YS2397', 174, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16334, 1, N'YS2558', 175, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16335, 1, N'YS2558', 176, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16336, 1, N'YS2558', 177, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16337, 1, N'YS2442', 178, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16338, 1, N'YS2442', 179, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16339, 1, N'YS2558', 180, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16340, 1, N'YS2558', 181, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16341, 1, N'YS2558', 182, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16342, 1, N'YS2442', 183, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16343, 1, N'YS2397', 184, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16344, 1, N'YS2558', 185, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16345, 1, N'YS2558', 186, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16346, 1, N'YS2558', 187, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16347, 1, N'YS2558', 188, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16348, 1, N'YS2442', 189, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16349, 1, N'YS2442', 190, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16350, 1, N'YS2442', 191, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16351, 1, N'YS2558', 192, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16352, 1, N'YS2442', 193, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16353, 1, N'YS2397', 194, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16354, 1, N'YS2442', 195, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16355, 1, N'YS2442', 196, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16356, 1, N'YS2442', 197, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16357, 1, N'YS2397', 198, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16358, 1, N'YS2442', 199, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16359, 1, N'YS2558', 200, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16360, 1, N'YS2558', 201, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16361, 1, N'YS2442', 202, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16362, 1, N'YS2397', 203, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16363, 1, N'YS2558', 204, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16364, 1, N'YS2558', 205, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16365, 1, N'YS2558', 206, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16366, 1, N'YS2558', 207, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16367, 1, N'YS2558', 208, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16368, 1, N'YS2442', 209, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16369, 1, N'YS2442', 210, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16370, 1, N'YS2442', 211, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16371, 1, N'YS2442', 212, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16372, 1, N'YS2442', 213, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16373, 1, N'YS2442', 214, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16374, 1, N'YS2558', 215, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16375, 1, N'YS2558', 216, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16376, 1, N'09941', 217, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16377, 1, N'YS2442', 218, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16378, 1, N'YS2442', 219, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16379, 1, N'YS2442', 220, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16380, 1, N'YS2442', 221, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16381, 1, N'YS2397', 222, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16382, 1, N'YS2397', 223, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16383, 1, N'YS2442', 224, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16384, 1, N'YS2558', 225, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16385, 1, N'09941', 226, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16386, 1, N'YS2558', 227, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16387, 1, N'YS2397', 228, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16388, 1, N'YS2442', 229, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16389, 1, N'YS2558', 230, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16390, 1, N'09941', 231, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16391, 1, N'09941', 232, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16392, 1, N'YS2397', 233, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16393, 1, N'YS2397', 234, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16394, 1, N'YS2442', 235, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16395, 1, N'YS2558', 236, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16396, 1, N'YS2442', 237, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16397, 1, N'YS2442', 238, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16398, 1, N'09941', 241, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16399, 1, N'YS2442', 243, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16400, 1, N'YS2442', 244, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16401, 1, N'YS2558', 245, N'58', N'', CAST(N'2020-09-02 02:00:03.857' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16402, 1, N'09941', 133, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16403, 1, N'09941', 134, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16404, 1, N'09775', 135, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16405, 1, N'20491', 136, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16406, 1, N'YS2397', 137, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16407, 1, N'YS2558', 138, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16408, 1, N'YS2558', 139, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16409, 1, N'YS2558', 140, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16410, 1, N'YS2558', 141, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16411, 1, N'YS2558', 142, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16412, 1, N'YS2558', 143, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16413, 1, N'YS2558', 144, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16414, 1, N'YS2558', 145, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16415, 1, N'YS2558', 146, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16416, 1, N'YS2558', 147, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16417, 1, N'YS2558', 148, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16418, 1, N'YS2558', 149, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16419, 1, N'YS2558', 150, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16420, 1, N'YS2558', 151, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16421, 1, N'YS2558', 152, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16422, 1, N'YS2442', 153, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16423, 1, N'YS2397', 154, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16424, 1, N'YS2558', 155, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16425, 1, N'YS2442', 156, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16426, 1, N'YS2442', 157, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16427, 1, N'09941', 158, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16428, 1, N'YS2558', 159, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16429, 1, N'YS2558', 160, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16430, 1, N'YS2558', 161, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16431, 1, N'YS2558', 162, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16432, 1, N'YS2558', 163, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16433, 1, N'YS2558', 164, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16434, 1, N'YS2558', 165, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16435, 1, N'YS2558', 166, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16436, 1, N'YS2442', 167, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16437, 1, N'YS2558', 168, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16438, 1, N'YS2442', 169, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16439, 1, N'YS2558', 170, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16440, 1, N'YS2558', 171, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16441, 1, N'YS2442', 172, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16442, 1, N'YS2442', 173, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16443, 1, N'YS2442', 174, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16444, 1, N'YS2558', 175, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16445, 1, N'YS2558', 176, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16446, 1, N'YS2558', 177, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16447, 1, N'YS2442', 178, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16448, 1, N'YS2442', 179, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16449, 1, N'YS2558', 180, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16450, 1, N'YS2558', 181, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16451, 1, N'YS2558', 182, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16452, 1, N'YS2442', 183, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16453, 1, N'YS2442', 184, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16454, 1, N'YS2558', 185, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16455, 1, N'YS2558', 186, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16456, 1, N'YS2442', 187, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16457, 1, N'YS2442', 188, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16458, 1, N'YS2558', 189, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16459, 1, N'YS2442', 190, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16460, 1, N'YS2442', 191, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16461, 1, N'YS2558', 192, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16462, 1, N'YS2442', 193, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16463, 1, N'YS2397', 194, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16464, 1, N'YS2442', 195, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16465, 1, N'YS2442', 196, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16466, 1, N'YS2442', 197, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16467, 1, N'YS2442', 198, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16468, 1, N'YS2442', 199, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16469, 1, N'YS2442', 200, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16470, 1, N'YS2397', 201, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16471, 1, N'YS2442', 202, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16472, 1, N'YS2442', 203, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16473, 1, N'YS2558', 204, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16474, 1, N'YS2558', 205, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16475, 1, N'YS2558', 206, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16476, 1, N'YS2558', 207, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16477, 1, N'YS2558', 208, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16478, 1, N'YS2442', 209, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16479, 1, N'YS2442', 210, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16480, 1, N'YS2442', 211, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16481, 1, N'YS2442', 212, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16482, 1, N'YS2442', 213, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16483, 1, N'YS2442', 214, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16484, 1, N'YS2558', 215, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16485, 1, N'YS2558', 216, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16486, 1, N'09941', 217, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16487, 1, N'YS2442', 218, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16488, 1, N'YS2442', 219, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16489, 1, N'YS2442', 220, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16490, 1, N'YS2442', 221, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16491, 1, N'YS2397', 222, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16492, 1, N'YS2397', 223, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16493, 1, N'YS2442', 224, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16494, 1, N'YS2442', 225, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16495, 1, N'09941', 226, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16496, 1, N'YS2558', 227, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16497, 1, N'YS2397', 228, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16498, 1, N'YS2442', 229, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16499, 1, N'YS2558', 230, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16500, 1, N'09941', 231, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16501, 1, N'YS2397', 232, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16502, 1, N'YS2397', 233, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16503, 1, N'YS2397', 234, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16504, 1, N'YS2442', 235, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16505, 1, N'YS2558', 236, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16506, 1, N'YS2442', 237, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16507, 1, N'YS2442', 238, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16508, 1, N'09941', 241, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16509, 1, N'YS2442', 243, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16510, 1, N'YS2442', 244, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
INSERT [dbo].[Sol_Permission] ([PermID], [UserType], [UserName], [DataSetID], [RCode], [CreateBy], [CreateTime], [Modifier], [ModifyTime]) VALUES (16511, 1, N'YS2558', 245, N'1', N'', CAST(N'2020-09-02 02:00:03.863' AS DateTime), NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Sol_Permission] OFF
GO
SET IDENTITY_INSERT [dbo].[Sol_ProductInfo] ON 

GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (1, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003420', N'DNDC V200R001', N'VR20181205095813371', N'VB20190905171232817', N'201812_PDCP_RB10', N'VD20190905171351270', N'201812_PDCP_RB10D001', N'何宇锋 09775', N'楚莹莹 20491', N'楚莹莹 20491', N'楚莹莹 20491')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (2, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003420', N'DNDC V200R001', N'VR20181205095813371', N'VB20190905173240770', N'201812_PDCP_RB16', N'VD20190905173406348', N'201812_PDCP_RB16D001', N'楚莹莹 20491', N'何宇锋 09775', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (3, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003420', N'DNDC V200R001', N'VR20181205095813371', N'VB20190909110614014', N'201812_PDCP_RB19', N'VD20190909114510577', N'201812_PDCP_RB19D001', N'lile YS2397', N'lile YS2397', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (4, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003206', N'数字化和智慧类解决方案', N'VR20191128162718621', N'VB20191128164959074', N'areB02', N'VD20191128165003074', N'areB02D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (5, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003206', N'数字化和智慧类解决方案', N'VR20191128162718621', N'VB20191128162734593', N'areB01', N'VD20191128162745995', N'areB01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (6, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR002095', N'IVS V100R001', N'VR20191128145121828', N'VB20191128145126609', N'极客强人挑战赛B01', N'VD20191128145132969', N'极客强人挑战赛B01D001', N'fengjicheng YS2558', N'lile YS2397', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (7, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200309145222892', N'移动审批 V1001B01', N'VD20200309145226548', N'移动审批 V1001B01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (8, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200310164225128', N'移动审批 V1001B02', N'VD20200310164228972', N'移动审批 V1001B02D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (9, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200311162816618', N'移动审批 V1001B03', N'VD20200311162820524', N'移动审批 V1001B03D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (10, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200311164633855', N'移动审批 V1001B04', N'VD20200311164637496', N'移动审批 V1001B04D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (11, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200311165634542', N'移动审批 V1001B05', N'VD20200311165638323', N'移动审批 V1001B05D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (12, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200311170825494', N'移动审批 V1001B06', N'VD20200311170828963', N'移动审批 V1001B06D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (13, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200311172610384', N'移动审批 V1001B07', N'VD20200311172614181', N'移动审批 V1001B07D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (14, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200312160551009', N'移动审批 V1001B08', N'VD20200312160556509', N'移动审批 V1001B08D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (15, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200312161145102', N'移动审批 V1001B09', N'VD20200312161149618', N'移动审批 V1001B09D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (16, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200312161923930', N'移动审批 V1001B10', N'VD20200312161927523', N'移动审批 V1001B10D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (17, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200312162130898', N'移动审批 V1001B11', N'VD20200312162134258', N'移动审批 V1001B11D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (18, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200312163238523', N'移动审批 V1001B12', N'VD20200312163242866', N'移动审批 V1001B12D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (19, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200312170005615', N'VB20200312170010771', N'非移动,不审批B01', N'VD20200312170015974', N'非移动,不审批B01D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (20, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR002012', N'H3C解决方案公共', N'VR20200316151312145', N'VB20200316151317614', N'sowhatB01', N'VD20200316151324270', N'sowhatB01D001', N'lile YS2397', N'lile YS2397', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (21, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200316163132085', N'移动审批 V1001B13', N'VD20200316163135898', N'移动审批 V1001B13D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (22, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200312170005615', N'VB20200317142330398', N'非移动,不审批B02', N'VD20200317142335492', N'非移动,不审批B02D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (23, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200312170005615', N'VB20200317142349257', N'非移动,不审批B03', N'VD20200317142353648', N'非移动,不审批B03D001', N'wangyuji YS2442', N'fengjicheng YS2558', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (24, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003420', N'DNDC V200R001', N'VR20181205095813371', N'VB20181207094508096', N'201812_PDCP_RB02', N'VD20181207094527877', N'201812_PDCP_RB02D001', N'朱月倩 09941', N'朱月倩 09941', N'朱月倩 09941', N'朱月倩 09941')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (25, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200318150908814', N'移动审批 V1001B14', N'VD20200318150912876', N'移动审批 V1001B14D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (26, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200319092617115', N'移动审批 V1001B15', N'VD20200319092622803', N'移动审批 V1001B15D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (27, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200320172006518', N'移动审批 V1001B16', N'VD20200320172010143', N'移动审批 V1001B16D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (28, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200323094709488', N'移动审批 V1001B17', N'VD20200323094713441', N'移动审批 V1001B17D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (29, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200312170005615', N'VB20200317142416992', N'非移动,不审批B05', N'VD20200317142420960', N'非移动,不审批B05D001', N'朱月倩 09941', N'朱月倩 09941', N'朱月倩 09941', N'朱月倩 09941')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (30, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200323141633636', N'移动审批 V1001B18', N'VD20200323141637307', N'移动审批 V1001B18D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (31, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200324100002530', N'我的名字 V01B01', N'VD20200324100007155', N'我的名字 V01B01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (32, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200324111923226', N'我的名字 V01B02', N'VD20200324111927070', N'我的名字 V01B02D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (33, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200324152944720', N'我的名字 V01B03', N'VD20200324152948564', N'我的名字 V01B03D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (34, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200324153756625', N'演示示例B01', N'VD20200324153800844', N'演示示例B01D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (35, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200324153810907', N'演示示例B02', N'VD20200324153815860', N'演示示例B02D001', N'fengjicheng YS2558', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (36, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200326110547906', N'我的名字 V01B04', N'VD20200326110552312', N'我的名字 V01B04D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (37, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200324153821610', N'演示示例B03', N'VD20200324153826281', N'演示示例B03D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (38, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200327141305557', N'我的名字 V01B05', N'VD20200327141309119', N'我的名字 V01B05D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (39, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200330104436214', N'VB20200330104441135', N'技术委员会主任审批模拟B01', N'VD20200330104444885', N'技术委员会主任审批模拟B01D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (40, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200331093456515', N'红牛云基地搭建项目B01', N'VD20200331093500593', N'红牛云基地搭建项目B01D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (41, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR002095', N'IVS V100R001', N'VR20191128145121828', N'VB20200331102225417', N'极客强人挑战赛B03', N'VD20200331102230886', N'极客强人挑战赛B03D001', N'wangyuji YS2442', N'lile YS2397', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (42, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200331143601864', N'我的名字 V01B06', N'VD20200331143605020', N'我的名字 V01B06D001', N'fengjicheng YS2558', N'wangyuji YS2442', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (43, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR002012', N'H3C解决方案公共', N'VR20200331144245207', N'VB20200331144249472', N'多待办问题B01', N'VD20200331144252769', N'多待办问题B01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (44, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200331150411346', N'我的名字 V01B07', N'VD20200331150414971', N'我的名字 V01B07D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (45, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200331153804014', N'红牛云基地搭建项目B02', N'VD20200331153809108', N'红牛云基地搭建项目B02D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (46, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200331153820592', N'红牛云基地搭建项目B03', N'VD20200331153824374', N'红牛云基地搭建项目B03D001', N'wangyuji YS2442', N'fengjicheng YS2558', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (47, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200331212518946', N'我的名字 V01B08', N'VD20200331212522821', N'我的名字 V01B08D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (48, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200331220206833', N'我的名字 V01B09', N'VD20200331220210708', N'我的名字 V01B09D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (49, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200331222823034', N'我的名字 V01B10', N'VD20200331222827362', N'我的名字 V01B10D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (50, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200401091213924', N'红牛云基地搭建项目B04', N'VD20200401091219017', N'红牛云基地搭建项目B04D001', N'wangyuji YS2442', N'fengjicheng YS2558', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (51, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200401091226439', N'红牛云基地搭建项目B05', N'VD20200401091308892', N'红牛云基地搭建项目B05D001', N'wangyuji YS2442', N'lile YS2397', N'wangyuji YS2442', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (52, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200401113228073', N'我的名字 V01B11', N'VD20200401113232105', N'我的名字 V01B11D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (53, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200401132001362', N'我的名字 V01B12', N'VD20200401132005205', N'我的名字 V01B12D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (54, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200401160036689', N'红牛云基地搭建项目B06', N'VD20200401160041658', N'红牛云基地搭建项目B06D001', N'wangyuji YS2442', N'lile YS2397', N'wangyuji YS2442', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (55, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200401162342905', N'红牛云基地搭建项目B07', N'VD20200401162347937', N'红牛云基地搭建项目B07D001', N'wangyuji YS2442', N'fengjicheng YS2558', N'wangyuji YS2442', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (56, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200401162353890', N'红牛云基地搭建项目B08', N'VD20200401162358733', N'红牛云基地搭建项目B08D001', N'fengjicheng YS2558', N'lile YS2397', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (57, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200402145645183', N'红牛云基地搭建项目B10', N'VD20200402145650105', N'红牛云基地搭建项目B10D001', N'wangyuji YS2442', N'朱月倩 09941', N'朱月倩 09941', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (58, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200402162128207', N'红牛云基地搭建项目B09', N'VD20200402162132800', N'红牛云基地搭建项目B09D001', N'wangyuji YS2442', N'朱月倩 09941', N'朱月倩 09941', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (59, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200403161101831', N'VB20200403161106316', N'测试B01', N'VD20200403161109800', N'测试B01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (60, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR002095', N'IVS V100R001', N'VR20191128145121828', N'VB20200403161331206', N'极客强人挑战赛B04', N'VD20200403161337503', N'极客强人挑战赛B04D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (61, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR002095', N'IVS V100R001', N'VR20191128145121828', N'VB20200403161331206', N'极客强人挑战赛B04', N'VD20200422145422187', N'极客强人挑战赛B04D002', N'lile YS2397', N'wangyuji YS2442', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (62, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003675', N'医保信息化解决方案', N'VR20200423154922616', N'VB20200423154929679', N'驳回的流程B01', N'VD20200423154936475', N'驳回的流程B01D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (63, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003675', N'医保信息化解决方案', N'VR20200423154922616', N'VB20200423160100052', N'驳回的流程B02', N'VD20200423160104568', N'驳回的流程B02D001', N'wangyuji YS2442', N'lile YS2397', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (64, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200507134849861', N'演示示例B05', N'VD20200507134855143', N'演示示例B05D001', N'wangyuji YS2442', N'lile YS2397', N'wangyuji YS2442', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (65, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200507134839955', N'演示示例B04', N'VD20200507134844299', N'演示示例B04D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (66, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200507134901424', N'演示示例B06', N'VD20200507134905627', N'演示示例B06D001', N'wangyuji YS2442', N'lile YS2397', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (67, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200507134913674', N'演示示例B07', N'VD20200507134917830', N'演示示例B07D001', N'wangyuji YS2442', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (68, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200509141556502', N'演示示例B08', N'VD20200509141601784', N'演示示例B08D001', N'lile YS2397', N'fengjicheng YS2558', N'wangyuji YS2442', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (69, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003419', N'DNEC V100R001', N'VR20200509145751795', N'VB20200509145757014', N'整体流程测试 V100R001B01', N'VD20200509145800998', N'整体流程测试 V100R001B01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (70, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003675', N'医保信息化解决方案', N'VR20200509151045716', N'VB20200509151049920', N'整体流程测试 V100R003B01', N'VD20200509151053466', N'整体流程测试 V100R003B01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (71, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003675', N'医保信息化解决方案', N'VR20200509152254763', N'VB20200509152258684', N' V100R04B01', N'VD20200509152302778', N' V100R04B01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (72, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003419', N'DNEC V100R001', N'VR20200509154255027', N'VB20200509154258980', N' V100R001B01', N'VD20200509154302198', N' V100R001B01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (73, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200509154702526', N'VB20200509154708557', N' V100R002B02', N'VD20200509154712323', N' V100R002B02D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (74, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200509141612127', N'演示示例B09', N'VD20200509141620455', N'演示示例B09D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (75, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200509141629096', N'演示示例B10', N'VD20200509141635533', N'演示示例B10D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (76, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200512091943853', N'红牛云基地搭建项目B20', N'VD20200512091951759', N'红牛云基地搭建项目B20D001', N'wangyuji YS2442', N'lile YS2397', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (77, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200512092003040', N'红牛云基地搭建项目B21', N'VD20200512092009290', N'红牛云基地搭建项目B21D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (78, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200512092017509', N'红牛云基地搭建项目B22', N'VD20200512092023134', N'红牛云基地搭建项目B22D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (79, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'PR003182', N'VB20200511163901785', N'解决方案规划公共B01', N'VD20200511164239204', N'解决方案规划公共B01D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (80, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003420', N'DNDC V200R001', N'VR20181205095813371', N'VB20181205095826278', N'201812_PDCP_RB01', N'VD20181205095837793', N'201812_PDCP_RB01D001', N'朱月倩 09941', N'朱月倩 09941', N'朱月倩 09941', N'朱月倩 09941')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (81, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003675', N'医保信息化解决方案', N'PR003675', N'VB20200514150411037', N'医保信息化解决方案B01', N'VD20200514150419115', N'医保信息化解决方案B01D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (82, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR002095', N'IVS V100R001', N'VR20191128145121828', N'VB20200514152914549', N'极客强人挑战赛B10', N'VD20200514152920268', N'极客强人挑战赛B10D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (83, N'PL000021', N'无线产品线', N'PL000037', N'PT000258', N'移动通信解决方案', N'PT000281', N'PR003156', N'UE V200R001', N'VR20200516175707184', N'VB20200516175850227', N'UE V200R001B01', N'VD20200516175944332', N'UE V200R001B01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (84, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR001753', N'IPTelephony V100R001', N'VR20200517152055703', N'VB20200517152055719', N'IPTelephony V100R001B01', N'VD20200517152055735', N'IPTelephony V100R001B01D001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (85, N'PL000021', N'无线产品线', N'PL000037', N'PT000258', N'移动通信解决方案', N'PT000281', N'PR003685', N'移动通信维护开发项目', N'VR20200519151328567', N'VB20200519151329036', N'移动通信维护开发项目B01', N'VD20200519151329536', N'移动通信维护开发项目B01D001', N'朱月倩 09941', N'wangyuji YS2442', N'朱月倩 09941', N'朱月倩 09941')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (86, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR001785', N'IDC V100R003', N'VR20200520093133121', N'VB20200520093133637', N'IDC V100R003B01', N'VD20200520093134293', N'IDC V100R003B01D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (87, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR001746', N'MEN V100R001', N'VR20200520105301191', N'VB20200520105301754', N'MEN V100R001B01', N'VD20200520105302332', N'MEN V100R001B01D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (88, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR001645', N'IPTV V100R001', N'VR20200517184520614', N'VB20200526152623569', N'IPTV V100R001B10', N'VD20200526152624194', N'IPTV V100R001B10D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (89, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR002095', N'IVS V100R001', N'VR20191128145121828', N'VB20200403161331206', N'极客强人挑战赛B04', N'VD20200710085215558', N'极客强人挑战赛B04D20200710v001', N'lile YS2397', N'wangyuji YS2442', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (90, N'PL000030', N'云与智能产品线', N'PL000037', N'PT000262', N'云计算解决方案 SPDT', N'PT000281', N'PR003192', N'H3Cloud V600R001', N'VR20200710102308150', N'VB20200710102308729', N'H3Cloud V600R001B06', N'VD20200710102309338', N'H3Cloud V600R001B06D001', N'lile YS2397', N'lile YS2397', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (91, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324153751860', N'VB20200324153821610', N'演示示例B03', N'VD20200710103856613', N'演示示例B03D20200710v001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (92, N'PL000021', N'无线产品线', N'PL000037', N'PT000258', N'移动通信解决方案', N'PT000281', N'PR003049', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目', N'VR20200528162419466', N'VB20200528162420059', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B01', N'VD20200528162420622', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B01D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (93, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200331093452093', N'VB20200401162342905', N'红牛云基地搭建项目B07', N'VD20200713105244555', N'红牛云基地搭建项目B07D20200713v001', N'wangyuji YS2442', N'fengjicheng YS2558', N'wangyuji YS2442', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (94, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR002095', N'IVS V100R001', N'VR20191128145121828', N'VB20200403161331206', N'极客强人挑战赛B04', N'VD20200713143042128', N'极客强人挑战赛B04D01', N'朱月倩 09941', N'wangyuji YS2442', N'朱月倩 09941', N'朱月倩 09941')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (95, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200312161923930', N'移动审批 V1001B10', N'VD20200713153057545', N'移动审批维护测试 V1001B10D008', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (96, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR002095', N'IVS V100R001', N'VR20191128145121828', N'VB20200403161331206', N'极客强人挑战赛B04', N'VD20200713164501140', N'极客强人挑战赛B04D010203', N'lile YS2397', N'lile YS2397', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (97, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR002095', N'IVS V100R001', N'VR20191128145121828', N'VB20200403161331206', N'极客强人挑战赛B04', N'VD20200714095544699', N'极客强人挑战赛B04D2020071409', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (98, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200324152944720', N'我的名字 V01B03', N'VD20200714110521887', N'我的名字维护测试 V01B03Ddraft001', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (99, N'PL000021', N'无线产品线', N'PL000037', N'PT000258', N'移动通信解决方案', N'PT000281', N'PR003685', N'移动通信维护开发项目', N'VR20200519151328567', N'VB20200519151329036', N'移动通信维护开发项目B01', N'VD20200716135235803', N'移动通信维护开发项目B01D0716', N'朱月倩 09941', N'lile YS2397', N'朱月倩 09941', N'朱月倩 09941')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (100, N'PL000021', N'无线产品线', N'PL000037', N'PT000258', N'移动通信解决方案', N'PT000281', N'PR003685', N'移动通信维护开发项目', N'VR20200519151328567', N'VB20200519151329036', N'移动通信维护开发项目B01', N'VD20200716135925379', N'移动通信维护开发项目B01D0716002', N'lile YS2397', N'lile YS2397', N'朱月倩 09941', N'朱月倩 09941')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (101, N'PL000021', N'无线产品线', N'PL000037', N'PT000258', N'移动通信解决方案', N'PT000281', N'PR003685', N'移动通信维护开发项目', N'VR20200519151328567', N'VB20200519151329036', N'移动通信维护开发项目B01', N'VD20200716140833187', N'移动通信维护开发项目B01D0716003', N'lile YS2397', N'wangyuji YS2442', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (102, N'PL000021', N'无线产品线', N'PL000037', N'PT000258', N'移动通信解决方案', N'PT000281', N'PR003022', N'LTE OEM V100R001', N'VR20200528170808381', N'VB20200722150535269', N'LTE OEM V100R001B06', N'VD20200722150536004', N'LTE OEM V100R001B06D001', N'lile YS2397', N'lile YS2397', N'lile YS2397', N'lile YS2397')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (103, N'PL000021', N'无线产品线', N'PL000037', N'PT000258', N'移动通信解决方案', N'PT000281', N'PR003022', N'LTE OEM V100R001', N'VR20200528170808381', N'VB20200727134507109', N'LTE OEM V100R001B16', N'VD20200727134507890', N'LTE OEM V100R001B16D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (104, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200309145218439', N'VB20200323094709488', N'移动审批 V1001B17', N'VD20200729111706142', N'移动审批维护测试 V1001B17D要', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (105, N'PL000021', N'无线产品线', N'PL000037', N'PT000258', N'移动通信解决方案', N'PT000281', N'PR003049', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目', N'VR20200528162419466', N'VB20200729170957978', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B16', N'VD20200729170958853', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B16D001', N'wangyuji YS2442', N'fengjicheng YS2558', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (106, N'PL000021', N'无线产品线', N'PL000037', N'PT000258', N'移动通信解决方案', N'PT000281', N'PR003049', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目', N'VR20200528162419466', N'VB20200803152505526', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B11', N'VD20200803152506526', N'P5G V200R001 自筹 科技部 科技冬奥课题三项目B11D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (107, N'PL000022', N'智能管理与运维产品线', N'PL000037', N'PT000204', N'CloudNet解决方案 SPDT', N'PT000281', N'PR001900', N'CVS V100R001', N'VR20200805163658040', N'VB20200805163658884', N'CVS V100R001B19', N'VD20200805163659821', N'CVS V100R001B19D001', N'朱月倩 09941', N'朱月倩 09941', N'朱月倩 09941', N'朱月倩 09941')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (108, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003675', N'医保信息化解决方案', N'VR20200423154922616', N'VB20200813101020282', N'驳回的流程B16', N'VD20200813101021204', N'驳回的流程B16D001', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (109, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200312170005615', N'VB20200317142349257', N'非移动,不审批B03', N'VD20200817135630722', N'非移动,不审批B03D130', N'wangyuji YS2442', N'fengjicheng YS2558', N'wangyuji YS2442', N'wangyuji YS2442')
GO
INSERT [dbo].[Sol_ProductInfo] ([ID], [ProductLine_Code], [ProductLine_Name], [iSplanPLine_Code], [PDT_Code], [PDT_Name], [iSplanPDT_Code], [Release_Code], [Release_Name], [iSplanRelease_Code], [B_Code], [B_Name], [D_Code], [D_Name], [STDArch], [STDMgr], [SecondDeptMgr], [ThirdDeptMgr]) VALUES (110, N'PL000037', N'解决方案', N'PL000037', N'PT000281', N'解决方案开发', N'PT000281', N'PR003182', N'解决方案规划公共', N'VR20200324095956952', N'VB20200324111923226', N'我的名字 V01B02', N'VD20200818133735824', N'我的名字维护测试 V01B02D006', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558', N'fengjicheng YS2558')
GO
SET IDENTITY_INSERT [dbo].[Sol_ProductInfo] OFF
GO
