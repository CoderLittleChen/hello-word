
--http://crm.h3c.com:5555/H3C/main.aspx?etn=new_case&extraqs=id%3d%257b5dbdf61a-82ad-4fda-a8bd-aee369422925%257d&pagetype=entityrecord
select  a.new_barcode   from   View_CaseDataForRPA   a   where  a.new_barcode  is not null  
group  by  a.new_barcode  having(COUNT(a.new_barcode)>1)  ;

select   *   from 
(
	select  *,ROW_NUMBER()  over(partition by  a.new_barcode  order by  a.createdon) as rankNum    from  View_CaseDataForRPA     a
	where  a.new_barcode is  not null  and  a.new_barcode!=''
)  temp  where   temp.rankNum>=1  order by  temp.rankNum,temp.createdon desc;
	

select   ROW_NUMBER() over(order  by  a.new_caseId) as RankNum,a.new_barcode,CONVERT(varchar(100),a.new_caseId)  as url  
from   View_CaseDataForRPA  a  where  a.new_barcode='213130A1SSX15C000002';

select  *   from   View_CaseDataForRPA  a   where  a.new_barcode='213130A1SSX15C000002';

--CRM  sn  dan  caseId
--spms  dan  
--icms  caseId  
--RTS   sn  没问题    
--ibpm  sn   

--210235A1JNB169000003


--现在的sql语句
--"select  a.new_caseId,a.new_barcode   from   View_CaseDataForRPA  a  where  a.new_barcode='"+SerialNum.ToString()+"'  "

--"select   ROW_NUMBER() over(order  by  a.new_caseId) as RankNum,a.new_barcode,CONVERT(varchar(100),a.new_caseId)  as url  from   View_CaseDataForRPA  a  where  a.new_barcode='"+SerialNum.ToString()+"'  "

--"A2"+":"+"B"+(filterDataTableOfSNInfo.Rows.Count-1).ToString()

select  *   from   View_CaseDataForRPA   a   where  a.new_name='2017010103176';
select  *   from   View_CaseDataForRPA   a   where  a.new_name  like '2017%'   order  by  a.new_name;
select  *   from   View_CaseDataForRPA   a  where a.createdon>'2019-09-01' and  a.createdon<'2019-10-01'  order  by  a.createdon desc;
select  a.new_caseId,a.new_barcode   from   View_CaseDataForRPA  a  where  a.new_barcode='213130A1SSX15C000002';

--20160923159019

-------------------------------------CRM系统-----------------------------
--http://crm.h3c.com:5555/H3C/main.aspx?etn=new_case&extraqs=id%3d%257b5dbdf61a-82ad-4fda-a8bd-aee369422925%257d&pagetype=entityrecord

-------------------------------------待分析件电子流-----------------------------
--需要的参数   WF_ProcessUNID		WF_DocUNID  

--http://bpm06.h3c.com:800/bpm/app.nsf/frmOpenForm?readform&WF_FormNumber=P_h3c11003_001
--http://bpm06.h3c.com:800/bpm/linkey_workflow_engine.nsf/workflow_doc?readform&WF_ProcessUNID=EF30A6B29938A81748257DDA002134CD&WF_DocUNID=C01B5371548B12FC4825847700214148

--http://bpm06.h3c.com:800/bpm/linkey_workflow_engine.nsf/workflow_doc?readform&WF_ProcessUNID=EF30A6B29938A81748257DDA002134CD&WF_DocUNID=C8FE23E5C5111729482584A10035E3A7



--"=Hyperlink(""" + spms + "/spms/require/applicationDetails.do?REQUIREMENT_LINE_ID=" + outTableLinkInfo.Rows(a)("REQUIREMENT_LINE_ID").ToString() + "&req_type=" + outTableLinkInfo.Rows(a)("REQ_TYPE").ToString() + "&usertype=" + outTableLinkInfo.Rows(a)("usertype").ToString() + """," + """编号""" + ")"
--"=Hyperlink("""  + "/spms/require/applicationDetails.do?REQUIREMENT_LINE_ID=" + outTableLinkInfo.Rows(a)("REQUIREMENT_LINE_ID").ToString() + "&req_type=" + outTableLinkInfo.Rows(a)("REQ_TYPE").ToString() + "&usertype=" + outTableLinkInfo.Rows(a)("usertype").ToString() + """," + """编号""" + ")"


