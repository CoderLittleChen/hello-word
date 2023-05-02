--alter  table  PersonInfo  add  CardConfirmOpinion  varchar(200)    ;

--alter table PersonInfo  drop   column  CardConfirmOpinion ;

select   *   from  PersonInfo  a ;
select   *   from  V_PersonInfo  a;
select   *   from  V_ProjectPersonInfo  a;
select   *   from  V_ProjectPersonInfo_ALL  a;

--exec  sp_rename  'PersonInfo.CardConfirmopinion','CardConfirmOpinion';

--ALTER TABLE [dbo].[PersonInfo] ADD CardConfirmOpinion  NVARCHAR(100) NULL;



  
  
  
  