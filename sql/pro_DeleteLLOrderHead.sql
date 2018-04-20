/*
Ö»ÄÜÉ¾³ý¿Õµ¥
*/
CREATE PROCEDURE pro_DeleteLLOrderHead
		  	@tslh_id		varchar(4),	
			@tslh_no		varchar(20),
			@tslh_time		varchar(20),			
			@tsi_no			varchar(20),		
			@ts_no			varchar(20),				
			@tslh_remark		varchar(500)				
 AS

SET NOCOUNT ON

declare @cnt 	int
select @cnt = count(*) from table_stock_ll_head where tslh_no = @tslh_no
if (@cnt > 0)
	begin
		
		delete table_stock_ll_head
		where tslh_no = @tslh_no
		select MSG = 1

	end
else
	begin
		select MSG = 0
				
	end

SET NOCOUNT OFF

GO
