Alter  PROC [dbo].[P_ImportProConfigData]
    (
      @key UNIQUEIDENTIFIER ,
      @user NVARCHAR(200),
	  @configId smallint
    )
AS
    BEGIN
        DECLARE @rownum INT;
		--������Ŀ����
        DECLARE @SecondproName NVARCHAR(200) ,
					  @SecondManager nvarchar(200),
					  @SecondRoleType nvarchar(200),
					  @SecondIsFixedPerson  bit,
					  @SecondDetailId int;
		set @SecondDetailId=-1;
		--������Ŀ����
        DECLARE @ThirdproName NVARCHAR(200) ,
					@ThirdManager nvarchar(200),
					@ThirdRoleType nvarchar(200),
				    @ThirdIsFixedPerson  bit,
					@ThirdDetailId int;
		set @ThirdDetailId=-1;
		--�ļ���Ŀ����
        DECLARE @FourthproName NVARCHAR(200) ,
					@FourthManager nvarchar(200),
					@FourthRoleType nvarchar(200),
				    @FourthIsFixedPerson  bit,
					@FourthDetailId int;
		set @FourthDetailId=-1;
		declare @currentDate date;
		set @currentDate=GETDATE();

        DECLARE @error INT;   
        SET @error = 0; 

        BEGIN TRANSACTION;
        SELECT  *  INTO    #importData  FROM    ProductConfigImportData  WHERE   KeyId = @key;
  	
        SET @rownum = ( SELECT  MIN(ID)  FROM   #importData );
        WHILE @rownum IS NOT NULL
            BEGIN
				--��ѯ��Ŀ��Ӧ��DetailId
				select  @SecondproName=SecondProName,@SecondManager=SecondManager,@SecondRoleType=SecondRoleType,@SecondIsFixedPerson=SecondIsFixedPerson  from #importData  where  ID = @rownum;
				select  @ThirdproName=ThirdProName,@ThirdManager=ThirdManager,@ThirdRoleType=ThirdRoleType,@ThirdIsFixedPerson=ThirdIsFixedPerson  from #importData  where  ID = @rownum;
				select  @FourthproName=FourthProName,@FourthManager=FourthManager,@FourthRoleType=FourthRoleType,@FourthIsFixedPerson=FourthIsFixedPerson  from #importData  where  ID = @rownum;
				if(@SecondproName<>'')
					begin
						select @SecondDetailId=DetailId,@SecondManager=a.Manager,@SecondRoleType=a.RoleType,@SecondIsFixedPerson=a.IsFixedPerson  from   ProductConfigDetail  a   where  a.ProName=@SecondproName   and  a.ProLevel=4;
					end
				if(@ThirdproName<>'')
					begin
						select @ThirdDetailId=DetailId,@ThirdManager=a.Manager,@ThirdRoleType=a.RoleType,@ThirdIsFixedPerson=a.IsFixedPerson  from   ProductConfigDetail  a   where  a.ProName=@ThirdproName   and  a.ProLevel=5;
					end
				if(@FourthproName<>'')
					begin
						select @FourthDetailId=DetailId,@FourthManager=a.Manager,@FourthRoleType=a.RoleType,@FourthIsFixedPerson=a.IsFixedPerson  from   ProductConfigDetail  a   where  a.ProName=@FourthproName   and  a.ProLevel=6;
					end
				--�����ļ���Ŀ����
				--DetailId   -1  ��ʾû�иü���Ŀ���ƻ��������в�����
				--DetailId   xx    ����Ŀ���� ��ʾ�����ݿ�ͬһ�㼶�´��ڸ���Ŀ
				--select @SecondDetailId,@ThirdDetailId,@FourthDetailId;
				--select @SecondproName,@ThirdproName,@FourthproName;
				if(@SecondproName<>'')
					begin
						if(@SecondDetailId <>-1)
							begin
								--2���Ѵ���
								if(@ThirdproName<>'')
									begin
										if(@ThirdDetailId <>-1)
											begin
												--3���Ѵ���
												if(@FourthproName<>'')
													begin
														if(@FourthDetailId <>-1)
															begin
																--�ļ��Ѵ���  ֱ����һ��
																continue;
															end
														else	
															begin
																--2 3�Ѵ���  4������
																--����4����Ŀ
																insert    into  ProductConfigDetail 
																select  @configId,6,@FourthproName,@ThirdDetailId,@FourthIsFixedPerson,@FourthRoleType,@FourthManager,@user,@currentDate,null,null;
															end
													end
												else
													begin
														--2 3�Ѵ���  4û��
														continue;
													end
											end
										else
											begin
												--2������  3��������
												if(@FourthproName<>'')
													begin
														----2������  3��������  4����
														----����3 4
														insert    into  ProductConfigDetail 
														select  @configId,5,@ThirdproName,@SecondDetailId,@ThirdIsFixedPerson,@ThirdRoleType,@ThirdManager,@user,@currentDate,null,null;
														----������Detailid��Ҫ���²�ѯ
														select @ThirdDetailId=DetailId  from  ProductConfigDetail  where ProLevel=5 and ParentId=@SecondDetailId and ProName=@ThirdproName;

														insert    into  ProductConfigDetail 
														select  @configId,6,@FourthproName,@ThirdDetailId,@FourthIsFixedPerson,@FourthRoleType,@FourthManager,@user,@currentDate,null,null;
													end
												else
													begin
														--2������  3��������  4û��
														--����3
														insert    into  ProductConfigDetail 
														select  @configId,5,@ThirdproName,@SecondDetailId,@ThirdIsFixedPerson,@ThirdRoleType,@ThirdManager,@user,@currentDate,null,null;
													end
											end
									end
								else
									begin
										continue;
									end
							end
						else
							begin
								--2������ ���ݿ��в�����   ��Ҫ�ж��Ƿ���3 4��
								if(@ThirdproName<>'')
									begin
										if(@FourthproName<>'')
											begin
												----ֱ�Ӳ���2 3 4
												insert    into  ProductConfigDetail 
												select  @configId,4,@SecondproName,null,@SecondIsFixedPerson,@SecondRoleType,@SecondManager,@user,@currentDate,null,null;

												----�²���Ķ���DetailId ��ѯ
												select @SecondDetailId=DetailId  from  ProductConfigDetail  where ProLevel=4 and ParentId is null and ProName=@SecondproName;

												insert    into  ProductConfigDetail 
												select  @configId,5,@ThirdproName,@SecondDetailId,@ThirdIsFixedPerson,@ThirdRoleType,@ThirdManager,@user,@currentDate,null,null;

												----�²��������DetailId ��ѯ
												select @ThirdDetailId=DetailId  from  ProductConfigDetail  where ProLevel=5 and ParentId=@SecondDetailId and ProName=@ThirdproName;

												insert    into  ProductConfigDetail 
												select  @configId,6,@FourthproName,@ThirdDetailId,@FourthIsFixedPerson,@FourthRoleType,@FourthManager,@user,@currentDate,null,null;

											end
										else
											begin
												select 5;
												----ֱ�Ӳ���2 3
												insert    into  ProductConfigDetail 
												select  @configId,4,@SecondproName,null,@SecondIsFixedPerson,@SecondRoleType,@SecondManager,@user,@currentDate,null,null;

												----�²���Ķ���DetailId ��ѯ
												select @SecondDetailId=DetailId  from  ProductConfigDetail  where ProLevel=4 and ParentId is null and ProName=@SecondproName;

												insert    into  ProductConfigDetail 
												select  @configId,5,@ThirdproName,@SecondDetailId,@ThirdIsFixedPerson,@ThirdRoleType,@ThirdManager,@user,@currentDate,null,null;
											end
									end
								else
									begin
										--ֱ�Ӳ���2
										insert    into  ProductConfigDetail 
										select  @configId,4,@SecondproName,null,@SecondIsFixedPerson,@SecondRoleType,@SecondManager,@user,@currentDate,null,null;
									end
							end
					end


                DELETE  #importData  WHERE   ID = @rownum;
                SET @rownum = ( SELECT  MIN(ID)   FROM    #importData);
            END; 

        IF @@ERROR != 0  OR @error != 0
            BEGIN
                ROLLBACK TRANSACTION;
            END; 
        ELSE
            BEGIN
                COMMIT TRANSACTION; 
            END; 


    END; 