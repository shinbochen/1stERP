
CREATE PROCEDURE pro_AddCPRCOrderList
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


if (@cnt > 0)
	begin
		select MSG = 0

	end
else
	begin
		insert into table_stock_cprc_list( 
					tsch_no,
					tp_no,			
					tscl_amount)	
				values(			
					@tsch_no,
					@tp_no,			
					@tscl_amount )				
		
	
		
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
				@tsch_no + ' add'
		)
		select MSG = 1
				
	end

SET NOCOUNT OFF

GO
