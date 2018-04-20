/******************************************************
 *	得到符合条件送货单列表(包括所有信息)
 *	Author: shinbo.chen
 *  date: 2009/12/6
 *******************************************************/ 
CREATE PROCEDURE pro_QuerySalesOutputByTime
		  					@start			varchar(20),	
							@end				varchar(20)			
 AS

SET NOCOUNT ON

declare		@tsoh1_no		varchar(20)
declare		@detail			varchar(200)
declare		@tsol1_id		int


set		@start = @start+' 0:00:00'
set		@end	 = @end+ ' 23:59:59'

create table	#table_tmp
(
		tsoh1_no					varchar(20),	
		tsoh1_time				smalldatetime,
				
		tc_shortname		varchar(20),
		tsoh1_remark			varchar(500)
)

create table	#table_tmp1 (
	[tsol1_id] [int]  ,
	[tsoh_no] [varchar] (20)  ,
	[tp_no] [varchar] (20)  ,
	[tsol1_amount] [int]
) 

create table	#table_finalList
(
		tsoh1_id					int IDENTITY (1, 1) NOT NULL,
		tsoh1_no					varchar(20),	
		tsoh1_time				smalldatetime,
				
		tc_shortname		varchar(20),
		tsoh1_detail			varchar(500),---详情
		tsoh1_remark			varchar(500)
)
	


insert into #table_tmp
select  
	tsoh1_no,
	tsoh1_time,
	
	tc_shortname,
	tsoh1_remark
from table_sales_output_head where  tsoh1_time >= @start and tsoh1_time <= @end

while( exists(select * from #table_tmp) )
	begin
	
	set rowcount 1	
	select 	@tsoh1_no 	= tsoh1_no
	from		#table_tmp	
	set rowcount 0
	
	
	insert into #table_tmp1
	select  	
					tsol1_id ,
					tsoh_no,
					tp_no,
					tsol1_amount
	from table_sales_output_list where tsoh1_no=@tsoh1_no

	set @detail  = ''
	
	while( exists( select * from #table_tmp1) )
	begin
		
		set rowcount 1		
		select 	@tsol1_id = tsol1_id
		from 		#table_tmp1			
		set rowcount 0
		
		
		select @detail = @detail+tsoh_no+'['+tp_no+':'+convert(varchar,tsol1_amount)+']  '
		from	#table_tmp1
		where @tsol1_id = tsol1_id		
		
		delete 	from #table_tmp1 
		where		tsol1_id=@tsol1_id	
		
	end		
	
	insert into #table_finalList
	select		
					tsoh1_no,	
					tsoh1_time,
							
					tc_shortname,
					@detail,				---详情
					tsoh1_remark			
	from		#table_tmp
	where		tsoh1_no = @tsoh1_no
	
	delete 	from #table_tmp 
	where 	tsoh1_no = @tsoh1_no	
		
	end

select * from #table_finalList
drop 		table #table_finalList, #table_tmp, #table_tmp1

SET NOCOUNT OFF
GO
