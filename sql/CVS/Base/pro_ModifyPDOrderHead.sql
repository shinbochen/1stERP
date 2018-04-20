
CREATE PROCEDURE pro_ModifyPDOrderHead
		  	@tsph_id		varchar(4),	
			@tsph_no		varchar(20),
			@tsph_time		varchar(20),			
			@tsi_no			varchar(20),		
			@ts_no			varchar(20),				
			@tsph_remark		varchar(500)				
 AS

SET NOCOUNT ON

declare @cnt 	int
select @cnt = count(*) from table_stock_pd_head where tsph_no = @tsph_no
if (@cnt > 0)
	begin
		
		update table_stock_pd_head set
					tsph_no =@tsph_no,
					tsph_time=@tsph_time,		
					tsi_no=@tsi_no,		
					ts_no=@ts_no,			
					tsph_remark=@tsph_remark
		where tsph_no = @tsph_no
		select MSG = 1

	end
else
	begin
		select MSG = 0
				
	end

SET NOCOUNT OFF

GO
