
CREATE PROCEDURE pro_AddLLOrderList
		  	@tsll_id			varchar(4),	
				@tslh_no		varchar(20),
				@tp_no			varchar(20),			
				@tsll_amount		varchar(20)			
AS

SET NOCOUNT ON



declare 	@cnt 		int
declare 	@amount 	int
declare		@tsi_no		varchar(20)
declare		@today		smalldatetime

set				@today = getdate()

select 	@cnt = count(*) from table_stock_ll_list where tslh_no = @tslh_no and tp_no=@tp_no
select 	@tsi_no = tsi_no from table_stock_ll_head where tslh_no = @tslh_no


if (@cnt > 0 )
	begin
		select MSG = 0
	end
else
	begin
		insert into table_stock_ll_list( 
					tslh_no,
					tp_no,			
					tsll_amount)	
				values(			
					@tslh_no,
					@tp_no,			
					@tsll_amount )				
			

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
				@tslh_no + ' add'
		)				

		select MSG = 1
				
	end

SET NOCOUNT OFF

GO
