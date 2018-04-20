
CREATE PROCEDURE pro_AddSalesOrderList
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
select @cnt = count(*) from table_sales_order_list where tsoh_no = @tsoh_no and tp_no = @tp_no
if (@cnt > 0)
	begin
		select MSG = 0

	end
else
	begin
		insert into table_sales_order_list( 
					tsoh_no,
					tp_no,			
					tpp_price,		
					tsol_product_amount,	
					tsol_product_ship,	
					tsol_product_tax)	
				values(			
					@tsoh_no,
					@tp_no,			
					@tpp_price,		
					@tsol_product_amount,		
					@tsol_product_ship,
					@tsol_product_tax)		
		select MSG = 1
				
	end

SET NOCOUNT OFF
GO
