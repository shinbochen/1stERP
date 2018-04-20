
CREATE PROCEDURE pro_DeletePDOrderList
		  	@tspl_id			varchar(4),	
				@tsph_no		varchar(20),
				@tp_no			varchar(20),			
				@tspl_amount		varchar(20)				
AS

SET NOCOUNT ON

declare 	@cnt 		int
declare 	@amount 	int
declare		@tsi_no		varchar(20)
declare		@today		smalldatetime

set				@today = getdate()

select 	@cnt = count(*) 
from table_stock_pd_list 
where tsph_no = @tsph_no and tp_no=@tp_no

select 	@tsi_no = tsi_no 
from 		table_stock_pd_head 
where 	tsph_no = @tsph_no

if (@cnt > 0 )
	begin
		select 	@amount = tspl_amount 
		from table_stock_pd_list 
		where tsph_no = @tsph_no and tp_no=@tp_no
		
		delete table_stock_pd_list 
		where	 tsph_no = @tsph_no and tp_no=@tp_no
			
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
				@tsph_no + ' delete'
		)
		select MSG = 1
	end
else
	begin
		select MSG = 0
				
	end

SET NOCOUNT OFF

GO
