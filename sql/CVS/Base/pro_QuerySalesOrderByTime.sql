/******************************************************
 *	得到符合条件订单列表(包括所有信息)
 *	Author: shinbo.chen
 *  date: 2009/12/6
 *******************************************************/ 
CREATE PROCEDURE pro_QuerySalesOrderByTime
		  					@start			varchar(20),	
								@end				varchar(20)			
 AS

SET NOCOUNT ON

declare		@tsoh_no		varchar(20)
declare		@tp_no			varchar(20)
declare		@all_product		varchar(200)
declare		@all_money		money
declare		@recv_money		money
declare		@send_product		varchar(200)
declare		@count 			int

set		@start = @start+' 0:00:00'
set		@end	 = @end+ ' 23:59:59'
create table	#table_tmp
(
		tsoh_id					int,
		tsoh_no					varchar(20),	
		tsoh_time				smalldatetime,
				
		tc_shortname		varchar(20),
		ts_no						varchar(20),
		tsoh_lead_time	smalldatetime,
		tsoh_lead_addr	varchar(100),
		tsoh_remark			varchar(500)
)

create table	#table_tmp1 (
	[tsol_id] [int]  ,
	[tp_no] [varchar] (20)  ,
	[tpp_price] [float]  ,
	[tsol_product_amount] [int]  ,
	[tsol_product_tax] [float]
) 

create table	#table_finalList
(
		tsoh_id			int,
		tsoh_no			varchar(20),	
		tsoh_time		smalldatetime,
				
		tc_shortname		varchar(20),
		ts_no			varchar(20),
		tsoh_lead_time		smalldatetime,
		tsoh_lead_addr		varchar(100),
		tsol_all_product		varchar(200), --- 产品数目
		tsol_all_money		money,	--- 总价
		tsol_send_product	varchar(200),	--- 已发货品		
		tsol_recv_money	money,	--- 已收钱
		tsoh_remark		varchar(500)
)
	


insert into #table_tmp
select  
	tsoh_id,
	tsoh_no,
	tsoh_time,
	
	tc_shortname,
	ts_no,
	tsoh_lead_time,
	tsoh_lead_addr,
	tsoh_remark
from table_sales_order_head where  tsoh_time >= @start and tsoh_time <= @end

while( exists(select * from #table_tmp) )
	begin
	
	set rowcount 1	
	select 	@tsoh_no 	= tsoh_no
	from	#table_tmp	
	set rowcount 0
	
	
	insert into #table_tmp1
	select  	tsol_id ,
						tp_no,
						tpp_price,
						tsol_product_amount,
						tsol_product_tax
	from 	table_sales_order_list where tsoh_no=@tsoh_no

	--- 得到订单总额与所有产品详情 start
	set @all_money  = 0
	set @all_product = ''
	set @send_product = ''
	while( exists( select * from #table_tmp1) )
		begin
			
			set rowcount 1		
			select 	@tp_no 	= tp_no
			from	#table_tmp1		
			set rowcount 0
	
			delete from #table_tmp1 
			where	tp_no=@tp_no
			
			set @all_money = @all_money+dbo.func_getSalesOrderMoneySummary(@tsoh_no, @tp_no )
			set @all_product = @all_product + dbo.func_getSalesOrderProductSummary(@tsoh_no, @tp_no ) + '  '
			
			select 	@count = sum( tsol1_amount) 
			from 		table_sales_output_list
			where		tsoh_no = @tsoh_no and tp_no = @tp_no
			
			if( @count >0 )
				begin
					set @send_product = @send_product + @tp_no  + ':'+ convert( varchar, @count)+'台 '
				end
						
		end		
	--- 得到订单总额与所有产品详情 end
	
	set @recv_money = dbo.func_getSalesOrderRecvMoneySummary( @tsoh_no )
	insert into #table_finalList
	select	
				tsoh_id,
				tsoh_no,
				tsoh_time,
				
				tc_shortname,
				ts_no,
				tsoh_lead_time,
				tsoh_lead_addr,
				@all_product,
				@all_money,
				@send_product ,
				@recv_money,
				tsoh_remark
	from	#table_tmp
	where	tsoh_no = @tsoh_no
	
	delete 	from #table_tmp 
	where tsoh_no = @tsoh_no	
		
	end

select * from #table_finalList
drop table 		#table_finalList, #table_tmp, #table_tmp1

SET NOCOUNT OFF
GO
