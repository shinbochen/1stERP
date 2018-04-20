/******************************************************
 *	��ʱ��------�ͻ��������
 *	Author: shinbo.chen
 *  date: 2009/12/6
 *******************************************************/ 
CREATE PROCEDURE pro_QueryCustomerBuyDetailByTime
		  					@start			varchar(20),	
								@end				varchar(20)			
 AS

SET NOCOUNT ON


declare		@want					float
declare		@got					float
declare		@got1					float
declare		@tc_shortname	varchar(20)
declare		@tsoh_no			varchar(20)
declare		@tp_no				varchar(20)
declare		@remark				varchar(500)

set		@start = @start+' 0:00:00'
set		@end	 = @end+ ' 23:59:59'

create table	#table_finalList
(
		tfl_id				int IDENTITY (1, 1) NOT NULL ,
		tfl_start			varchar(20),	 -- ��ʼʱ��
		tfl_end				varchar(20),	 -- ����ʱ��
				
		tc_shortname	varchar(20),	 -- �ͻ�
		tfl_want			float,	 			 -- �������
		tfl_got				float,				 -- ʵ�ʽ��
		tfl_remark		varchar(500)	-- ����
)

create table	#table_tmp
(
		tc_id									int,
		tc_shortname					varchar(20)
)
	

create table	#table_tmp1
(
		tsoh_id									int,
		tsoh_no									varchar(20)
)

create table #table_tmp2
(
		tp_no									varchar(20),
		tp_amount							int
)

-- ÿ���ͻ����в�Ʒ���ܺ�
create table #table_tmp3
(
		tp_no									varchar(20),
		tp_amount							int
)

/****
��ʱ�����
*/
insert into #table_tmp
select  
			tc_id,
			tc_shortname
from table_customer

while( exists(select * from #table_tmp) )
	begin
	
	set rowcount 1	
	select 	@tc_shortname 	= tc_shortname
	from	#table_tmp	
	set rowcount 0
	
	insert into #table_tmp1
	select  
				tsoh_id,
				tsoh_no
	from table_sales_order_head
	where tc_shortname = @tc_shortname	
	
	set @remark = ''
	set @want = 0
	set @got = 0
	----------------��������������������ϸ��Ϣ��������-------------
	while( exists(select * from #table_tmp1) )
		begin			
				set rowcount 1	
				select 	@tsoh_no 	= tsoh_no
				from	#table_tmp1	
				set rowcount 0
				
				
				-- �õ��˶�����ÿ����Ʒ������
				insert into #table_tmp2
				select  	
					tp_no,
					tsol_product_amount
				from table_sales_order_list where tsoh_no=@tsoh_no
				
				-- ����˿ͻ����в�Ʒ������
				insert into #table_tmp3
				select  	
					tp_no,
					tsol_product_amount
				from table_sales_order_list where tsoh_no=@tsoh_no
				
				-- �õ��˶������ܽ�� ���ۼ�
				while( exists( select * from #table_tmp2) ) 
					begin
							
							set rowcount 1	
							select 	@tp_no 	= tp_no
							from	#table_tmp2	
							set rowcount 0
							-- �õ����ʵĽ��
							set @want= @want + dbo.func_getSalesOrderMoneySummary(@tsoh_no, @tp_no )
					
							delete from #table_tmp2
							where	@tp_no = tp_no
					end		
				
				
				-- �õ��˶�������� ���ۼ�
				set	@got1 = dbo.func_getSalesOrderRecvMoneySummary( @tsoh_no )
				if (@got1 > 0 )
					begin
						set @got = @got + @got1					
					end
				
				delete	from #table_tmp1
				where tsoh_no=@tsoh_no
		end
	-----------------------------
	
	----�õ��˿ͻ�������ϸ��Ϣ	start
	insert into #table_tmp2
	select
		tp_no,
		sum(tp_amount)
	from #table_tmp3 group by tp_no
	
	delete from #table_tmp3
	
	while( exists( select * from #table_tmp2) ) 
			begin
					
					set rowcount 1	
					select @tp_no = tp_no, @remark = @remark+ tp_no + ':' +convert( varchar, tp_amount) + ' '
					from	#table_tmp2	
					set rowcount 0
			
					delete from #table_tmp2
					where	@tp_no = tp_no
			end			
	----�õ��˿ͻ�������ϸ��Ϣ	end
	
	if (@want > 0 or @got > 0 )
		begin
		
		insert into #table_finalList
								(
									tfl_start,	 			-- ��ʼʱ��
									tfl_end,	 				-- ����ʱ��
											
									tc_shortname,	 		-- �ͻ�
									tfl_want,	 			 	-- �������
									tfl_got,				 	-- ʵ�ʽ��
									tfl_remark
								)
								values(
									@start,
									@end,
									
									@tc_shortname,
									@want,
									@got,
									@remark
								)
		end
		
	delete	from #table_tmp
	where tc_shortname=@tc_shortname
			
	end

select @want = sum(tfl_want), @got =sum(tfl_got)
from #table_finalList

insert into #table_finalList
								(
									tfl_start,	 			-- ��ʼʱ��
									tfl_end,	 				-- ����ʱ��
											
									tc_shortname,	 		-- �ͻ�
									tfl_want,	 			 	-- �������
									tfl_got,				 	-- ʵ�ʽ��
									tfl_remark
								)
								values(
									'------',
									'------',
									
									'------',
									@want,
									@got,
									'------'
								)

select * from #table_finalList
drop table #table_finalList, #table_tmp, #table_tmp1,#table_tmp2,#table_tmp3

SET NOCOUNT OFF
GO
