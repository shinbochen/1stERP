/******************************************************
 *	�õ�������Ϣ
 *	Author: shinbo.chen
 *  date: 2009/12/6
 *******************************************************/ 
CREATE PROCEDURE pro_QueryFinanceSummaryByTime
		  					@start			varchar(20),	
								@end				varchar(20)			
 AS

SET NOCOUNT ON


declare		@in				float
declare		@out			float
declare		@balance	float
declare		@cntin		int
declare		@cntout		int
declare		@tbi_no		varchar(20)
declare		@remark		varchar(500)


set		@start = @start+' 0:00:00'
set		@end	 = @end+ ' 23:59:59'

create table	#table_tmp
(
		tbi_id					int,
		tbi_no					varchar(20)
)
create table	#table_finalList
(
		tfs_id				int IDENTITY (1, 1) NOT NULL ,
		tfs_start			varchar(20),	 -- ��ʼʱ��
		tfs_end				varchar(20),	 -- ����ʱ��
				
		tfs_account		varchar(20),	 -- �ʻ�
		tfs_in				varchar(20),				 -- ����
		tfs_out				varchar(20),				 -- ֧��
		tfs_balance		varchar(20),				 -- ����
		tfs_remark		varchar(500)
)
	

/****
��ʱ�����

*/
insert into #table_tmp
select  
			tbi_id,
			tbi_no
from table_bank_information

while( exists(select * from #table_tmp) )
	begin
	
	set rowcount 1
	
	select 	@tbi_no 	= tbi_no
	from	#table_tmp
	
	set rowcount 0
	
		
	select @in = sum(trc_amount), @cntin = count(*) 
	from	table_running_account
	where tbi_no=@tbi_no and trc_amount >0 and trc_time >= @start	and trc_time <= @end
	
	
	select @out = sum(trc_amount),  @cntout = count(*) 
	from	table_running_account
	where tbi_no=@tbi_no and trc_amount <0	and trc_time >= @start	and trc_time <= @end
	
	select @balance = sum(trc_amount) 
	from	table_running_account
	where tbi_no=@tbi_no and trc_time >= @start	and trc_time <= @end
	
	if @cntin > 0 or @cntout >0
		begin
			insert into #table_finalList
			(
				tfs_start,	 								-- ��ʼʱ��
				tfs_end,	 									-- ����ʱ��
						
				tfs_account,	 -- �ʻ�
				tfs_in,				 -- ����
				tfs_out,				 -- ֧��
				tfs_balance,				 -- ����
				tfs_remark	
			)
			values(
				@start,
				@end,
				
				@tbi_no,
				@in,
				@out,
				@balance,
				'in:'+convert(varchar, @cntin) + ' out:'+	convert(varchar, @cntout)				
			)
		end

	delete	from #table_tmp
	where tbi_no=@tbi_no
			
	end


set		@cntin = 0
set		@cntout = 0

select @in = sum(trc_amount), @cntin = count(*) 
from	table_running_account
where trc_amount >0 and trc_time >= @start	and trc_time <= @end

select @out = sum(trc_amount),  @cntout = count(*) 
from	table_running_account
where trc_amount <0 and trc_time >= @start	and trc_time <= @end

select @balance = sum(trc_amount) 
from	table_running_account
where trc_time >= @start	and trc_time <= @end

insert into #table_finalList
(
	tfs_start,	 								-- ��ʼʱ��
	tfs_end,	 									-- ����ʱ��
			
	tfs_account,	 						-- �ʻ�
	tfs_in,				 -- ����
	tfs_out,				 -- ֧��
	tfs_balance,				 -- ����
	tfs_remark

)
values(
'---------',
'---------',

'---------',
@in,
@out,
@balance,
'in:'+convert(varchar, @cntin) + ' out:'+	convert(varchar, @cntout)								
)

/****
insert �ָ���

*/	

insert into #table_finalList
(
	tfs_start,	 								-- ��ʼʱ��
	tfs_end,	 									-- ����ʱ��
			
	tfs_account,	 						-- �ʻ�
	tfs_in,				 -- ����
	tfs_out,				 -- ֧��
	tfs_balance,				 -- ����
	tfs_remark

)
values(
'##########',
'##########',

'##########',
'##########',
'##########',
'##########',
'##########'					
)

/****
����
*/

insert into #table_tmp
select  
			tbi_id,
			tbi_no
from table_bank_information

while( exists(select * from #table_tmp) )
	begin
	
	set rowcount 1
	
	select 	@tbi_no 	= tbi_no
	from	#table_tmp
	
	set rowcount 0
	
		
	select @in = sum(trc_amount), @cntin = count(*) 
	from	table_running_account
	where tbi_no=@tbi_no and trc_amount >0	
	
	
	select @out = sum(trc_amount),  @cntout = count(*) 
	from	table_running_account
	where tbi_no=@tbi_no and trc_amount <0	
	
	select @balance = sum(trc_amount) 
	from	table_running_account
	where tbi_no=@tbi_no
	
	if @cntin > 0 or @cntout >0
		begin
			insert into #table_finalList
			(
				tfs_start,	 								-- ��ʼʱ��
				tfs_end,	 									-- ����ʱ��
						
				tfs_account,	 -- �ʻ�
				tfs_in,				 -- ����
				tfs_out,				 -- ֧��
				tfs_balance,				 -- ����
				tfs_remark	
			)
			values(
				'0',
				'now',
				
				@tbi_no,
				@in,
				@out,
				@balance,
				'in:'+convert(varchar, @cntin) + ' out:'+	convert(varchar, @cntout)				
			)
		end

	delete	from #table_tmp
	where tbi_no=@tbi_no
			
	end


set		@cntin = 0
set		@cntout = 0

select @in = sum(trc_amount), @cntin = count(*) 
from	table_running_account
where trc_amount >0

select @out = sum(trc_amount),  @cntout = count(*) 
from	table_running_account
where trc_amount <0

select @balance = sum(trc_amount) 
from	table_running_account

insert into #table_finalList
(
	tfs_start,	 								-- ��ʼʱ��
	tfs_end,	 									-- ����ʱ��
			
	tfs_account,	 						-- �ʻ�
	tfs_in,				 -- ����
	tfs_out,				 -- ֧��
	tfs_balance,				 -- ����
	tfs_remark

)
values(
'--------',
'--------',

'--------',
@in,
@out,
@balance,
'in:'+convert(varchar, @cntin) + ' out:'+	convert(varchar, @cntout)								
)


select * from #table_finalList
drop table #table_finalList, #table_tmp

SET NOCOUNT OFF
GO
