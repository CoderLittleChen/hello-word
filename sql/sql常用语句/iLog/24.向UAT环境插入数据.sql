use PersonalInput;

select  *   from   UserInfo  a  where  a.ChnNamePY  like '%chenmin%'  and  a.RegionAccount like '%2689%';

select  *   from   UserInfo  a  where  a.DeptName='研发业务部';

--delete  from UserInfo  where Uid='FAA677D0-120D-4633-A083-720391458951'

--insert  into  UserInfo   
--select NEWID(),'陈敏','ys2689','50040641','研发业务部','cys2689','ys2689','chenmin','0',GETDATE(),'H3C\c02853','server',
--GETDATE(),0,0,'T04','2018-12-19 00:00:00.000','N',1,1

select  *  from   HourInfo_New   a  where   a.Creator  like '%chenmin ys2689%'  order by  a.Date desc;

select  *  from   HourInfo_New   a  where   a.Creator  like '%liucaixuan%'  order by  a.Date desc;

select  *  from   HourInfoDetailHistory   a  where   a.Creator  like '%liucaixuan%'  order by  a.Date desc;



select  *  from   HourInfoMainHistory  a  where a.Creator like '%liucaixuan%'  order by  a.CreateTime desc;

select  *  from   ProductInfo   a     where  a.ProID='7C08DFCD-1220-454E-962E-4A660CCB1403';

select  *  from   HourInfoDetailHistory   a  where   a.Creator  like '%chenmin ys2689%'  order by  a.Date desc;
select  *  from   HourInfoMainHistory   a  where  id='563373';

select  MAX(ID)+1  from   HourInfo_New   a
intersect 

select  MAX(ID)+1  from   HourInfoDetailHistory   a;
--if OBJECT_ID('')  is  not null

--1376357	499982	7C08DFCD-1220-454E-962E-4A660CCB1403	2019-11-22 00:00:00.000	5	100	0	0	liucaixuan 03806	2019-11-25 14:29:57.750	liucaixuan 03806	2019-11-26 10:47:02.333	0	0	'22号日志反馈'

--1461529	507746	7C08DFCD-1220-454E-962E-4A660CCB1403	2019-11-27 00:00:00.000	3	100	0	0	liucaixuan 03806	2019-12-01 09:25:39.977	liucaixuan 03806	2019-12-01 09:25:39.977	0	0	'27号日志反馈'


--Main表数据  
--插入创建25号的数据
--507746	20191125623	1	0	50042458	2019-11-25 00:00:00.000	liucaixuan 03806	liucaixuan 03806	2019-11-25 01:00:11.710	0	03806	刘彩宣	0	0	0	0	0	NULL	NULL
--历史表  18号的数据
--499982	20191118980	1	0	50042458	2019-11-18 00:00:00.000	liucaixuan 03806	liucaixuan 03806	2019-11-18 01:00:10.823	0	03806	刘彩宣	0	0	0	0	0	NULL	NULL

select  *  from   HourInfoDetailHistory   a  where   a.Creator  like '%liucaixuan%'  order by  a.Date desc;

--557017
select  *  from   HourInfoMain  a  where a.Creator like '%chenmin ys2689%' ;

--532240
select  *  from   HourInfoMainHistory  a  where a.Creator like '%chenmin ys2689%'  order by  a.CreateTime desc;

--BillNo  20200107584  563374
select  MAX(id)+1  from   HourInfoMain   a;

select  *  from  HourInfoMain  a   where  a.BillNo='20200107544';

--563372
select  MAX(id)  from  HourInfoMainHistory  a;

select  MAX(id)  from  HourInfoDetailHistory  a;

select  *  from  HourInfoMainHistory  a;


--向UAT主表插入数据   
--insert   into HourInfoMain
--select  '20200107584',0,0,'50040641','2020-01-06 00:00:00.000','chenmin ys2689','chenmin ys2689','2020-01-06 01:00:11.710',0,'ys2689','陈敏',
--0,0,0,0,0,null,null

--向UAT主表历史表插入数据
--insert   into HourInfoMainHistory
--select  '563373','20191213212',0,0,'50040641','2019-11-18 00:00:00.000','chenmin ys2689','chenmin ys2689','2019-11-18 01:00:11.710',0,'ys2689','陈敏',
--0,0,0,0,0,null,null

--向UAT明细表插入数据
--1586528
--insert   into  HourInfo_New
--select 557017,'7C08DFCD-1220-454E-962E-4A660CCB1403','2019-11-27 00:00:00.000',3,100,0,0,'chenmin ys2689','2019-12-01 09:25:39.977','chenmin ys2689','2019-12-01 09:25:39.977',0,0,'27号日志反馈',0,0,null

--向UAT明细表历史表插入数据
--insert   into  HourInfoDetailHistory
--select 1726223,563373,'7C08DFCD-1220-454E-962E-4A660CCB1403','2019-11-22 00:00:00.000',5,100,0,0,'chenmin ys2689','2019-11-25 09:25:39.977','chenmin ys2689','2019-11-26 09:25:39.977',0,0,'22号日志反馈',0,0,null


select  *  from   HourInfoDetailHistory   a  where   a.Creator  like '%chenmin ys2689%'  order by  a.Date desc;

select  *  from   HourInfoMainHistory  a  where a.Creator like '%chenmin ys2689%'  order by  a.CreateTime desc;


select  *  from   HourInfo_New   a  where   a.Creator  like '%chenmin ys2689%'  order by  a.Date desc;

select  *  from   HourInfoMain  a  where a.Creator like '%chenmin ys2689%'  order by  a.CreateTime desc;

--update  HourInfoMainHistory  set  Status=0 where id='563373'



