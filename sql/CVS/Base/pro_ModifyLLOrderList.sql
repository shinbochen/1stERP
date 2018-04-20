
CREATE PROCEDURE pro_ModifyLLOrderList
		  	@tsll_id			varchar(4),	
			@tslh_no		varchar(20),
			@tp_no			varchar(20),			
			@tsll_amount		varchar(20)				
AS

SET NOCOUNT ON

declare 	@cnt 		int
declare 	@amount 	int
declare	@tsi_no		varchar(20)
declare	@today		smalldatetime

set				@today = getdate()

select 	@cnt = count(*) from table_stock_ll_list where tslh_no = @tslh_no and tp_no=@tp_no
select 	@tsi_no = tsi_no from table_stock_ll_head where tslh_no = @tslh_no

if (@cnt > 0 )
	begin
		select 	@amount = tsll_amount from table_stock_ll_list where tslh_no = @tslh_no and tp_no=@tp_no
		
		update table_stock_ll_list set 				
					tslh_no = @tslh_no,
					tp_no = @tp_no,		
					tsll_amount = @tsll_amount
		where	 tslh_no = @tslh_no and tp_no=@tp_no

		
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
				@amount,
				@tslh_no + ' modify'
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
				0 - convert(int,@tsll_amount),
				@tslh_no + ' modify'
		)
		select MSG = 1
		

	end
else
	begin
		select MSG = 0				
	end

SET NOCOUNT OFF

GO
