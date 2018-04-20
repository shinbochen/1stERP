/******************************************************
 *	��ʱ��------��Ʒ�������
 *	Author: shinbo.chen
 *  date: 2009/12/6
 *******************************************************/ 
CREATE PROCEDURE pro_QueryProductSalesDetailByTime
		  					@start			varchar(20),	
								@end				varchar(20)			
 AS

SET NOCOUNT ON


declare		@tfl_want					int
declare		@tfl_send					int

declare		@tsoh_no			varchar(20)
declare		@tsoh1_no			varchar(20)
declare		@tp_no				varchar(20)
declare		@tp_amount		int
declare		@tp_sum				float
declare		@tp_price			float
declare		@tp_id				int


set		@start = @start+' 0:00:00'
set		@end	 = @end+ ' 23:59:59'

create table	#table_finalList
(
		tfl_id				int IDENTITY (1, 1) NOT NULL ,
		tfl_start			varchar(20),	 -- ��ʼʱ��
		tfl_end				varchar(20),	 -- ����ʱ��
				
		tp_no					varchar(20),	 -- ��Ʒ
		tfl_want			int,	 				 -- ��������
		tfl_send			int,				 	 -- �ͻ�����
		
		tfl_sum				float					 -- �������
)

-- �������б�
create table	#table_tmp
(
		tsoh_no						varchar(20)
)
	
-- �ͻ������б�
create table	#table_tmp1
(
		tsoh1_no								varchar(20)
)

-- ������Ʒ�б�
create table #table_tmp2
(
		tp_id									int IDENTITY (1, 1) NOT NULL ,
		tsoh_no								varchar(20),
		tp_no									varchar(20),
		tp_amount							int,
		tp_price							float
)

-- �ͻ���Ʒ�б�
create table #table_tmp3
(
		tp_id									int IDENTITY (1, 1) NOT NULL ,
		tp_no									varchar(20),
		tp_amount							int
)



insert	into #table_tmp
select	tsoh_no
from		table_sales_order_head
where		tsoh_time >= @start and tsoh_time <= @end

insert 	into #table_tmp1
select	tsoh1_no
from		table_sales_output_head
where		tsoh1_time >= @start and tsoh1_time <= @end


-- �õ�������Ʒ�б�start
while( exists(select * from #table_tmp) )
	begin
	
		
	set rowcount 1	
	select 	@tsoh_no 	= tsoh_no
	from	#table_tmp	
	set rowcount 0
	
	
	insert	into	#table_tmp2
	select	
					@tsoh_no,
					tp_no,
					tsol_product_amount,					
					tpp_price
	from		table_sales_order_list
	where		tsoh_no = @tsoh_no
			
	delete	from #table_tmp
	where 	tsoh_no=@tsoh_no
			
	end
-- �õ�������Ʒ�б�end

-- �õ��ͻ���Ʒ�б�start
while( exists(select * from #table_tmp1) )
	begin
	
		
	set rowcount 1	
	select 	@tsoh1_no 	= tsoh1_no
	from	#table_tmp1	
	set rowcount 0
	
	
	insert	into	#table_tmp3
	select	
					tp_no,
					tsol1_amount
	from		table_sales_output_list
	where		tsoh1_no = @tsoh1_no
			
	delete	from #table_tmp1
	where 	tsoh1_no=@tsoh1_no
			
	end
-- �õ��ͻ���Ʒ�б�end


-- �õ��������������start
while(  exists(select * from #table_tmp2) )
	begin
		
		set rowcount 1	
		select 	
						@tp_id = tp_id,
						@tsoh_no = tsoh_no,
						@tp_no 	= tp_no,
						@tp_amount = tp_amount,
						@tp_price = tp_price
		from		#table_tmp2	
		set rowcount 0
		
		delete #table_tmp2
		where	tp_id = @tp_id
		
		set @tp_sum = dbo.func_getSalesOrderMoneySummary2( @tsoh_no, @tp_no )
		
		if( exists( select * from #table_finalList where tp_no=@tp_no) )
			begin
				
				update	#table_finalList set
								tfl_want = tfl_want+@tp_amount,
								tfl_sum = tfl_sum+@tp_sum
				where		tp_no = @tp_no							
			
			end
		else
			begin
				insert into #table_finalList
										(
											
											tfl_start,	 -- ��ʼʱ��
											tfl_end,	 -- ����ʱ��
													
											tp_no,	 -- ��Ʒ
											tfl_want,	 				 -- ��������
											tfl_send,				 	 -- �ͻ�����
											
											tfl_sum				
										)
										values(
											@start,	 			-- ��ʼʱ��
											@end,	 				-- ����ʱ��
													
											@tp_no,	 			-- ��Ʒ
											@tp_amount,	 	-- ��������
											0,				 	 	-- �ͻ�����
											
											@tp_sum	  		-- �������
									)
			end
	
	end
-- �õ��������������end

-- �õ��ͻ�����start
while(  exists(select * from #table_tmp3) )
	begin
		
		set rowcount 1	
		select 	
						@tp_id = tp_id,
						@tp_no 	= tp_no,
						@tp_amount = tp_amount
		from		#table_tmp3	
		set rowcount 0
		
		delete #table_tmp3
		where	tp_id = @tp_id
				
		if( exists( select * from #table_finalList where tp_no=@tp_no) )
			begin
				
				update	#table_finalList set
								tfl_send = tfl_send+@tp_amount
				where		tp_no = @tp_no				
			
			end
		else
			begin
				insert into #table_finalList
										(
											
											tfl_start,	 -- ��ʼʱ��
											tfl_end,	 -- ����ʱ��
													
											tp_no,	 -- ��Ʒ
											tfl_want,	 				 -- ��������
											tfl_send,				 	 -- �ͻ�����
											
											tfl_sum				
										)
										values(
											@start,	 			-- ��ʼʱ��
											@end,	 				-- ����ʱ��
													
											@tp_no,	 			-- ��Ʒ
											0,	 				-- ��������
											@tp_amount,				 	 	-- �ͻ�����
											
											0	  		-- �������
									)
			
			end
	
	end
-- �õ��ͻ�����end

-- ͳ��


select @tfl_want = sum(tfl_want), @tfl_send =sum(tfl_send), @tp_sum = sum(tfl_sum)
from #table_finalList


insert into #table_finalList
										(
											
											tfl_start,	 -- ��ʼʱ��
											tfl_end,	 -- ����ʱ��
													
											tp_no,	 -- ��Ʒ
											tfl_want,	 				 -- ��������
											tfl_send,				 	 -- �ͻ�����
											
											tfl_sum				
										)
										values(
											'------',	 		-- ��ʼʱ��
											'------',	 		-- ����ʱ��
													
											'------',	 		-- ��Ʒ
											@tfl_want,	 	-- ��������
											@tfl_send,		-- �ͻ�����
											
											@tp_sum	  		-- �������
									)
									

select * from #table_finalList
drop table #table_finalList, #table_tmp, #table_tmp1,#table_tmp2,#table_tmp3

SET NOCOUNT OFF
GO
