--����ACID  A(ԭ���� Atomicity)
--����߱�ԭ���Ե�2�ַ�ʽ

create procedure  P_SyncProductInfo
as
	begin
		--��������Ӱ�������
		set nocount on
		--����֮��  ��������  ���̻ع�
		set xact_abort on
		begin try
			begin  transaction
				--dml����  update  insert
			commit
		end try
		begin catch
			if(xact_state()=-1)
				begin
					rollback transaction
				end
		end catch
	end


--C(һ���� Consistency)
--I(������  Isolation)
--�����ִ���ǻ������ŵ� 
--����֮���໥Ӱ��������Ϊ�����  �����ظ���  �ö�