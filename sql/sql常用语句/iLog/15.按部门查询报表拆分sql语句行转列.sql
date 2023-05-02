select ISNULL( ROW_NUMBER() OVER(ORDER BY PDTCode,FirstProCode,SecondProCode,ThirdProCode,FourthProCode),0) rowID,
sum(sumPer/sumMon) sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,
SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName,SecondDeptName,SecondDeptCode 

into #SelectAllPro from #temp_table
where SecondDeptCode is not null and SecondDeptCode<>''''
group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,
		ThirdProCode,ThirdProName,FourthProCode,FourthProName,SecondDeptName,SecondDeptCode;

--conditionΪ��
select SecondDeptName,sum(sumPer) as SumAll into #SelectAllPer from #SelectAllPro '+isnull(@contion,'')+' group by SecondDeptName;
select a.*,b.SumAll from #SelectAllPro a inner join #SelectAllPer b on a.SecondDeptName=b.SecondDeptName '+isnull(@contion,'')'



--condition��Ϊ��
select ProductLineCode,PDTCode,FirstProCode,SecondProCode,ThirdProCode,FourthProCode into #pro from #SelectAllPro '+isnull(@contion,'')+';

select SecondDeptName,SecondDeptCode,sum(sumPer) as SumAll into #SelectAllPer from #SelectAllPro sp 
where 
exists
(
select * from #pro where ProductLineCode=sp.ProductLineCode 
and PDTCode=sp.PDTCode and FirstProCode=sp.FirstProCode and SecondProCode=sp.SecondProCode and ThirdProCode=sp.ThirdProCode and FourthProCode=sp.FourthProCode
) group by SecondDeptName,SecondDeptCode;

select sp.*,b.SumAll from #SelectAllPro sp inner join #SelectAllPer b on sp.SecondDeptCode=b.SecondDeptCode  
where exists 
(
select * from #pro where ProductLineCode=sp.ProductLineCode
and PDTCode=sp.PDTCode and FirstProCode=sp.FirstProCode and SecondProCode=sp.SecondProCode and ThirdProCode=sp.ThirdProCode and FourthProCode=sp.FourthProCode

--50041349,
--50041443,50041444,50041993,
select  *  from  Department  a  where  a.DeleteFlag=0    and  a.DeptCode='50041993';

select  *   from  WorkHourDetail a;

--select *  from (SELECT SecondDeptCode,SecondDeptName,SUM(Percents) as Percents  FROM WorkHourDetailView /*����Դ*/
--group  by  SecondDeptCode,SecondDeptName)

SELECT *  FROM WorkHourDetailView
AS P
PIVOT 
(
    SUM(Percents/*��ת�к� �е�ֵ*/) FOR 
    p.SecondDeptName/*��Ҫ��ת�е���*/ IN ([�����ն��з���],[�з���Ϣ����],[��ȫ�з���],[��������]/*�е�ֵ*/)
) AS T