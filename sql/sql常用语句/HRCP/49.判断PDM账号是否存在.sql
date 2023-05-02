

--select * from 
--openquery([PMD_HRCP], 'select u.user_id,u.h3jobcode,u.user_name,u.h3cuserstatus from infodba.vv_usr u where u.h3cuserstatus=''valid_user'' And u.h3jobcode=''待传入notesid'' ')


--用这个语句来执行    直接查这个表来查询账号是否存在 
select  *   from   PDMUserInfo   a;