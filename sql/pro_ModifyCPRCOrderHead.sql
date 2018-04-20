
CREATE PROCEDURE pro_ModifyCPRCOrderHead
		  	@tsch_id		varchar(4),	
			@tsch_no		varchar(20),
			@tsch_time		varchar(20),			
			@tsi_no			varchar(20),		
			@ts_no			varchar(20),				
			@tsch_remark		varchar(500)				
 AS

SET NOCOUNT ON

declare @cnt 	int
select @cnt = count(*) from table_stock_cprc_head where tsch_no = @tsch_no
if (@cnt > 0)
	begin
		
		update table_stock_cprc_head set
					tsch_no =@tsch_no,
					tsch_time=@tsch_time,		
					tsi_no=@tsi_no,		
					ts_no=@ts_no,			
					tsch_remark=@tsch_remark
		where tsch_no = @tsch_no
		select MSG = 1

	end
else
	begin
		select MSG = 0				
	end
SET NOCOUNT OFF

GO
