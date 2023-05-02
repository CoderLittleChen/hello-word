select  *  from  specMS_AppConstantValue  a  where  a.AppConstantID =
(
	select  a.AppConstantID from   specMS_AppConstant  a  where  a.TypeCode='ProductImportance'
)

select  *  from  specMS_AppConstantValue  a  where  a.AppConstantID =
(
	select  a.AppConstantID  from   specMS_AppConstant  a  where  a.TypeCode='ProductSource'
)

select  *  from  specMS_AppConstantValue  a  where  a.AppConstantID =
(
	select  a.AppConstantID  from   specMS_AppConstant  a  where  a.TypeCode='ProductVerification'
)

select  *  from  specMS_AppConstantValue  a  where  a.AppConstantID =
(
	select  a.AppConstantID  from   specMS_AppConstant  a  where  a.TypeCode='ProColumnParam'
)

select  *  from   specMS_AppConstantValue a  where  a.AppConstantID='cb9cf13c-4341-440a-a14c-9e5276abfecb'