use PersonalInput;
insert    into   HourInfoDetailHistory
select  *  from   HourInfo_New  a 
where  a.Date<='2019-10-31';