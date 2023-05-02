Alter  PROC [dbo].[P_ImportProConfigData]
    (
      @key UNIQUEIDENTIFIER ,
      @user NVARCHAR(200),
	  @configId smallint
    )
AS
    BEGIN
        DECLARE @rownum INT;
		--二级项目变量
        DECLARE @SecondproName NVARCHAR(200) ,
					  @SecondManager nvarchar(200),
					  @SecondRoleType nvarchar(200),
					  @SecondIsFixedPerson  bit,
					  @SecondDetailId int;
		set @SecondDetailId=-1;
		--三级项目变量
        DECLARE @ThirdproName NVARCHAR(200) ,
					@ThirdManager nvarchar(200),
					@ThirdRoleType nvarchar(200),
				    @ThirdIsFixedPerson  bit,
					@ThirdDetailId int;
		set @ThirdDetailId=-1;
		--四级项目变量
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
				--查询项目对应的DetailId
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
				--存在四级项目名称
				--DetailId   -1  表示没有该级项目名称或在数据中不存在
				--DetailId   xx    有项目名称 表示在数据库同一层级下存在该项目
				--select @SecondDetailId,@ThirdDetailId,@FourthDetailId;
				--select @SecondproName,@ThirdproName,@FourthproName;
				if(@SecondproName<>'')
					begin
						if(@SecondDetailId <>-1)
							begin
								--2级已存在
								if(@ThirdproName<>'')
									begin
										if(@ThirdDetailId <>-1)
											begin
												--3级已存在
												if(@FourthproName<>'')
													begin
														if(@FourthDetailId <>-1)
															begin
																--四级已存在  直接下一步
																continue;
															end
														else	
															begin
																--2 3已存在  4不存在
																--插入4级项目
																insert    into  ProductConfigDetail 
																select  @configId,6,@FourthproName,@ThirdDetailId,@FourthIsFixedPerson,@FourthRoleType,@FourthManager,@user,@currentDate,null,null;
															end
													end
												else
													begin
														--2 3已存在  4没填
														continue;
													end
											end
										else
											begin
												--2级存在  3级不存在
												if(@FourthproName<>'')
													begin
														----2级存在  3级不存在  4填了
														----插入3 4
														insert    into  ProductConfigDetail 
														select  @configId,5,@ThirdproName,@SecondDetailId,@ThirdIsFixedPerson,@ThirdRoleType,@ThirdManager,@user,@currentDate,null,null;
														----三级的Detailid需要重新查询
														select @ThirdDetailId=DetailId  from  ProductConfigDetail  where ProLevel=5 and ParentId=@SecondDetailId and ProName=@ThirdproName;

														insert    into  ProductConfigDetail 
														select  @configId,6,@FourthproName,@ThirdDetailId,@FourthIsFixedPerson,@FourthRoleType,@FourthManager,@user,@currentDate,null,null;
													end
												else
													begin
														--2级存在  3级不存在  4没填
														--插入3
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
								--2级填了 数据库中不存在   需要判断是否有3 4级
								if(@ThirdproName<>'')
									begin
										if(@FourthproName<>'')
											begin
												----直接插入2 3 4
												insert    into  ProductConfigDetail 
												select  @configId,4,@SecondproName,null,@SecondIsFixedPerson,@SecondRoleType,@SecondManager,@user,@currentDate,null,null;

												----新插入的二级DetailId 查询
												select @SecondDetailId=DetailId  from  ProductConfigDetail  where ProLevel=4 and ParentId is null and ProName=@SecondproName;

												insert    into  ProductConfigDetail 
												select  @configId,5,@ThirdproName,@SecondDetailId,@ThirdIsFixedPerson,@ThirdRoleType,@ThirdManager,@user,@currentDate,null,null;

												----新插入的三级DetailId 查询
												select @ThirdDetailId=DetailId  from  ProductConfigDetail  where ProLevel=5 and ParentId=@SecondDetailId and ProName=@ThirdproName;

												insert    into  ProductConfigDetail 
												select  @configId,6,@FourthproName,@ThirdDetailId,@FourthIsFixedPerson,@FourthRoleType,@FourthManager,@user,@currentDate,null,null;

											end
										else
											begin
												select 5;
												----直接插入2 3
												insert    into  ProductConfigDetail 
												select  @configId,4,@SecondproName,null,@SecondIsFixedPerson,@SecondRoleType,@SecondManager,@user,@currentDate,null,null;

												----新插入的二级DetailId 查询
												select @SecondDetailId=DetailId  from  ProductConfigDetail  where ProLevel=4 and ParentId is null and ProName=@SecondproName;

												insert    into  ProductConfigDetail 
												select  @configId,5,@ThirdproName,@SecondDetailId,@ThirdIsFixedPerson,@ThirdRoleType,@ThirdManager,@user,@currentDate,null,null;
											end
									end
								else
									begin
										--直接插入2
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