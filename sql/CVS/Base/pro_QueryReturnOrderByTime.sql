/******************************************************
 *	得到符合条件退货单列表(包括所有信息)
 *	Author: shinbo.chen
 *  date: 2009/12/6
 *******************************************************/ 
CREATE PROCEDURE pro_QueryReturnOrderByTime
		  					@start			varchar(20),	
								@end				varchar(20)			
 AS

SET NOCOUNT ON

declare		@troh_no		varchar(20)
declare		@tp_no			varchar(20)
declare		@all_product		varchar(200)
declare		@send_product		varchar(200)
declare		@count 			int

set		@start = @start+' 0:00:00'
set		@end	 = @end+ ' 23:59:59'
create table	#table_tmp
(
		troh_id					int,
		troh_no					varchar(20),	
		troh_time				smalldatetime,
				
		tc_shortname		varchar(20),
		ts_no						varchar(20),
		troh_remark			varchar(500)
)


create table	#table_finalList
(
		troh_id			int,
		troh_no			varchar(20),	
		troh_time		smalldatetime,
				
		tc_shortname		varchar(20),
		ts_no						varchar(20),
		trol_all_product		varchar(200), --- 产品数目
		trol_send_product	varchar(200),	--- 已发货品		
		troh_remark		varchar(500)
)
	


insert into #table_tmp
select  
	troh_id,
	troh_no,
	troh_time,
	
	tc_shortname,
	ts_no,
	troh_remark
from table_return_order_head where  troh_time >= @start and troh_time <= @end

while( exists(select * from #table_tmp) )
	begin
	
	set rowcount 1	
	select 	@troh_no 	= troh_no
	from	#table_tmp	
	set rowcount 0
		
		
	--- 得到所有产品详情 start
	set @all_product = ''
	set @send_product = ''
	
	select @all_product = @all_product+tp_no+':'+convert( varchar,trol_amount) + ' '
	from table_return_order_list
	where troh_no=@troh_no


	select @send_product = @send_product+tp_no+':'+convert( varchar,sum(trol1_amount)) + ' '
	from table_return_output_list 
	where		troh_no = @troh_no
	group by tp_no
		
	--- 得到所有产品详情 end
	
	insert into #table_finalList
	select	
				troh_id,
				troh_no,
				troh_time,
				
				tc_shortname,
				ts_no,
				@all_product,
				@send_product,
				troh_remark
	from	#table_tmp
	where	troh_no = @troh_no
	
	delete 	from #table_tmp 
	where troh_no = @troh_no	
		
	end

select * from #table_finalList
drop table 		#table_finalList, #table_tmp

SET NOCOUNT OFF
GO
