
CREATE PROCEDURE pro_ModifyLLOrderHead
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
		
		update table_stock_ll_head set
					tslh_no =@tslh_no,
					tslh_time=@tslh_time,		
					tsi_no=@tsi_no,		
					ts_no=@ts_no,			
					tslh_remark=@tslh_remark
		where tslh_no = @tslh_no
		select MSG = 1

	end
else
	begin
		select MSG = 0
				
	end

SET NOCOUNT OFF

GO
