--create table	Customers
--(
--	customerid  varchar(10),
--	city  nvarchar(20)
--)

--create table	Orders
--(
--	orderid  int,
--	customerid  nvarchar(10)
--)

--insert into Customers
--select  'aa','china'
--union
--select  'bb','Korea'
--union
--select  'cc','Franch'
--union
--select  'dd','Japan'

--insert into  Orders 
--select  1,'aa'
--union 
--select  2,'aa'
--union 
--select  3,'bb'
--union 
--select  4,'bb'
--union
--select  5,'bb'
--union
--select  6,'cc'
--union 
--select  7,'bb'

--找出订单数量小于3  并且来自china的顾客

select  a.customerid,COUNT(a.customerid) as orderNum  from  Orders   a  left  join Customers b on  a.customerid=b.customerid
where b.city='china'
group by a.customerid
having COUNT(a.customerid)<3
order by  orderNum;

select  *  from  Customers  a  left   join  Orders  b  on a.customerid=b.customerid;