begin try
begin transaction
	begin
		--select  *  from  bversionTemp  where productline_name  like '%Èí¼þ%';
		--select  *  from  specMS_SpecDataIDSet  a;
		insert   into   specMS_SpecDataIDSet 
		select 
		null as dataSrc,bversionno,Release_Code,left(bversioncname,50),PDT_Code,ProductLine_Code,
		(
			case  when CHARINDEX('Èí¼þ',ProductLine_Name)=0  then  1
			else 2  
			end 
		) as verType,1 as orderNo,4 as idLevel,0 as status,1 as flag,0 as blNumber,1 as show
		from  bversionTemp 
		commit transaction;
	end
end try
Begin Catch 
	Rollback transaction;
	DECLARE @ErrorMessage NVARCHAR(max);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	SELECT 
	@ErrorMessage = ERROR_MESSAGE(),
	@ErrorSeverity = ERROR_SEVERITY(),
	@ErrorState = ERROR_STATE();


	RAISERROR (@ErrorMessage,  -- Message text.
	@ErrorSeverity, -- Severity.
	@ErrorState     -- State.
	);
End Catch