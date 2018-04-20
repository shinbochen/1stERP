
CREATE PROCEDURE pro_ModifyCPRCOrderList
		  	@tscl_id			varchar(4),	
				@tsch_no		varchar(20),
				@tp_no			varchar(20),			
				@tscl_amount		varchar(20)				
AS

SET NOCOUNT ON

declare 	@cnt 			int
declare 	@amount 	int
declare 	@tsi_no 	varchar(20)
declare	@today		smalldatetime

set				@today = getdate()
select 	@cnt = count(*) from table_stock_cprc_list where tsch_no = @tsch_no and tp_no=@tp_no
select	@tsi_no = tsi_no from table_stock_cprc_head where tsch_no = @tsch_no

if (@cnt > 0 )
	begin
		select 	@amount = tscl_amount from table_stock_cprc_list where tsch_no = @tsch_no and tp_no=@tp_no
		
		update table_stock_cprc_list set 				
					tsch_no = @tsch_no,
					tp_no = @tp_no,		
					tscl_amount = @tscl_amount
		where	 tsch_no = @tsch_no and tp_no=@tp_no

		
		insert into	table_stock_bill(
				tsb_time,
				tsi_no,
				tp_no,
				tsb_amount,
				tsb_ref_no
		)
		values(
				@today,
				@tsi_no,
				@tp_no,
				0-@amount,
				@tsch_no + ' modify'
		)

	
		insert into	table_stock_bill(
				tsb_time,
				tsi_no,
				tp_no,
				tsb_amount,
				tsb_ref_no
		)
		values(
				@today,
				@tsi_no,
				@tp_no,
				@tscl_amount,
				@tsch_no + ' modify'
		)

		select MSG = 1
		

	end
else
	begin
		select MSG = 0				
	end

SET NOCOUNT OFF
GO
