--事务ACID  A(原子性 Atomicity)
--事务具备原子性的2种方式

create procedure  P_SyncProductInfo
as
	begin
		--不返回受影响的行数
		set nocount on
		--开启之后  遇到错误  立刻回滚
		set xact_abort on
		begin try
			begin  transaction
				--dml操作  update  insert
			commit
		end try
		begin catch
			if(xact_state()=-1)
				begin
					rollback transaction
				end
		end catch
	end


--C(一致性 Consistency)
--I(隔离型  Isolation)
--事务的执行是互不干扰的 
--事务之间相互影响的情况分为：脏读  不可重复读  幻读