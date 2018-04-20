
CREATE PROCEDURE pro_AddLLOrderHead
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
		select MSG = 0

	end
else
	begin
		insert into table_stock_ll_head( 
					tslh_no,
					tslh_time,			
					tsi_no,		
					ts_no,				
					tslh_remark)	
				values(			
					@tslh_no,
					@tslh_time,			
					@tsi_no,		
					@ts_no,				
					@tslh_remark )		
		select MSG = 1
				
	end

SET NOCOUNT OFF

GO
