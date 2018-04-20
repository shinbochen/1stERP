
CREATE PROCEDURE pro_AddCPRCOrderHead
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
		select MSG = 0

	end
else
	begin
		insert into table_stock_cprc_head( 
					tsch_no,
					tsch_time,			
					tsi_no,		
					ts_no,				
					tsch_remark)	
				values(			
					@tsch_no,
					@tsch_time,			
					@tsi_no,		
					@ts_no,				
					@tsch_remark )		
		select MSG = 1
				
	end

SET NOCOUNT OFF

GO
