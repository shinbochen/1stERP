CREATE function func_getSalesOrderProductSummary ( 
			@tsoh_no   	varchar(20),
			@tp_no		varchar(20)
			)
returns	varchar(200)
as
begin
	declare		@all_product		varchar(200)

	
	select 	@all_product = tp_no + ':' +convert( varchar,  tsol_product_amount) + '̨'
	from	table_sales_order_list where tsoh_no = @tsoh_no 	and tp_no=@tp_no


	return @all_product
end


