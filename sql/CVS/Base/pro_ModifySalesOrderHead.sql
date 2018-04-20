
CREATE PROCEDURE pro_ModifySalesOrderHead
		  	@tsoh_id		varchar(4),	
			@tsoh_no		varchar(20),
			@tsoh_time		varchar(20),			
			@tc_shortname		varchar(20),		
			@tci_no		varchar(20),		
			@ts_no			varchar(20),		
			@tsoh_lead_time	varchar(20),		
			@tsoh_lead_addr	varchar(100),				
			@tsoh_remark		varchar(500)				
 AS

SET NOCOUNT ON

declare @cnt 	int
select @cnt = count(*) from table_sales_order_head where tsoh_no = @tsoh_no
if (@cnt > 0)
	begin
		update 	table_sales_order_head 	set 
						tsoh_no = @tsoh_no,
						tsoh_time = @tsoh_time,			
						tc_shortname = @tc_shortname,			
						tci_no = @tci_no,	
						ts_no = @ts_no,	
						tsoh_lead_time = @tsoh_lead_time,	
						tsoh_lead_addr = @tsoh_lead_addr,				
						tsoh_remark = @tsoh_remark
		where tsoh_no = @tsoh_no	
		select MSG = 1

	end
else
	begin			
		select MSG = 0
				
	end

SET NOCOUNT OFF
GO
