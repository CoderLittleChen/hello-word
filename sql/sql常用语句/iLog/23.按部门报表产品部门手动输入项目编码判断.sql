
if(@projectCode<>'')
	begin
		if((select top 1 *  from #checkedDeptTable)!='')
			begin
				--ѡ���˲���
				if((select top 1 *  from #checkedProTable)!='')
					--ѡ���˲�Ʒ
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
								union 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
							end
						else
							begin
								--��ѯ��ǰ��
								insert into #temp_table 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
							end
					end
				else
					begin
						--�в���  û��Ʒ
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
								union 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
							end
						else
							begin
								--��ѯ��ǰ��
								insert into #temp_table 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
							end
					end
			end
		else 
			begin
				if((select top 1 *  from #checkedProTable)!='')
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
								union 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
							end
						else
							begin
								--��ѯ��ǰ��
								insert into #temp_table 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
							end
					end
				else
					--���źͲ�Ʒ������û��
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								and (whdh.ProductLineCode in(select * from #inputProjectTable) or   whdh.PDTCode in(select * from #inputProjectTable)  or   whdh.BVersionCode in(select * from #inputProjectTable) or   whdh.SecondProCode in(select * from #inputProjectTable) or   whdh.ThirdProCode in(select * from #inputProjectTable)  or   whdh.FourthProCode in(select * from #inputProjectTable)   )
								union 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
							end
						else
							begin
								--��ѯ��ǰ��
								insert into #temp_table 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								and (whd.ProductLineCode in(select * from #inputProjectTable) or   whd.PDTCode in(select * from #inputProjectTable)  or   whd.BVersionCode in(select * from #inputProjectTable) or   whd.SecondProCode in(select * from #inputProjectTable) or   whd.ThirdProCode in(select * from #inputProjectTable)  or   whd.FourthProCode in(select * from #inputProjectTable)   )
							end
					end
			end
	end
else 
	begin
		if((select top 1 *  from #checkedDeptTable)!='')
			begin
				--ѡ���˲���
				if((select top 1 *  from #checkedProTable)!='')
					--ѡ���˲�Ʒ
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								union 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
							end
						else
							begin
								--��ѯ��ǰ��
								insert into #temp_table 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
							end
					end
				else
					begin
						--�в���  û��Ʒ
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								union 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
							end
						else
							begin
								--��ѯ��ǰ��
								insert into #temp_table 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
							end
					end
			end
		else 
			begin
				if((select top 1 *  from #checkedProTable)!='')
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								union 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
							end
						else
							begin
								--��ѯ��ǰ��
								insert into #temp_table 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
							end
					end
				else
					--���źͲ�Ʒ������û��
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								insert into #temp_table 
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								union
								select   
									ID,
									whdh.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetailHistory  whdh
								inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
								union 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
							end
						else
							begin
								--��ѯ��ǰ��
								insert into #temp_table 
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
								union
								select   
									ID,
									whd.ProCode,
									ProName,
									ProductLineCode,
									ProductLineName,
									PDTCode,
									PDTName,
									BVersionCode,
									BVersionName,
									SecondProCode,
									SecondProName,
									ThirdProCode,
									ThirdProName,
									FourthProCode,
									FourthProName,
									UserCode,
									UserName,
									YearMonth,
									Percents,
									WorkingDay,
									DeptCode,
									DeptName,
									SecondDeptCode,
									SecondDeptName,
									StationCategoryCode,
									StationCategoryName,
									IsPDT,
									IsVendor,
									PDTCount,
									RoundCount,
									VendorCount 
								from  WorkHourDetail  whd
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
							end
					end
			end
	end