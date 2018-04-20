
CREATE PROCEDURE pro_AddPDOrderHead
		  @tsph_id		varchar(4),	
			@tsph_no		varchar(20),
			@tsph_time		varchar(20),			
			@tsi_no			varchar(20),		
			@ts_no			varchar(20),				
			@tsph_remark		varchar(500)				
 AS

SET NOCOUNT ON

declare @cnt 	int
select 	@cnt = count(*) from table_stock_pd_head where tsph_no = @tsph_no
if (@cnt > 0)
	begin
		select MSG = 0

	end
else
	begin
		insert into table_stock_pd_head( 
					tsph_no,
					tsph_time,			
					tsi_no,		
					ts_no,				
					tsph_remark)	
				values(			
					@tsph_no,
					@tsph_time,			
					@tsi_no,		
					@ts_no,				
					@tsph_remark )		
		select MSG = 1
				
	end

SET NOCOUNT OFF

GO
