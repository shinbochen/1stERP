
CREATE PROCEDURE pro_ModifySalesOrderList
		  	@tsol_id		varchar(4),	
			@tsoh_no		varchar(20),
			@tp_no			varchar(20),			
			@tpp_price	varchar(20),		
			@tsol_product_amount	varchar(20),		
			@tsol_product_ship	varchar(20),
			@tsol_product_tax	varchar(20)			
 AS

SET NOCOUNT ON

declare @cnt 	int
select @cnt = count(*) from table_sales_order_list where tsol_id = @tsol_id 
if (@cnt > 0)
	begin
		
		update table_sales_order_list	set 
					tsol_id =@tsol_id,	
					tsoh_no =@tsoh_no,
					tp_no =@tp_no,			
					tpp_price =@tpp_price,		
					tsol_product_amount =@tsol_product_amount,	
					tsol_product_ship= @tsol_product_ship,
					tsol_product_tax =@tsol_product_tax	
		where	tsol_id = @tsol_id
		select MSG = 1

	end
else
	begin
		select MSG = 0
				
	end

SET NOCOUNT OFF
GO