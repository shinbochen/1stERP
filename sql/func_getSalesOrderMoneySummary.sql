CREATE function func_getSalesOrderMoneySummary ( 
			@tsoh_no   	varchar(20),
			@tp_no		varchar(20)
			)
returns	float
as
begin
	declare		@all_money		float
	declare		@tci_no		varchar(20)
	declare		@rate			float

	select 	@tci_no = tci_no 
	from	table_sales_order_head
	where	tsoh_no = @tsoh_no

	select	@rate = tci_rate
	from	table_currency_information
	where	tci_no = @tci_no

	
	select 	@all_money =( tsol_product_amount*tpp_price)*(1+tsol_product_tax/100)+tsol_product_ship 
	from	table_sales_order_list 
	where 	tsoh_no = @tsoh_no 	and tp_no=@tp_no


	return @all_money*@rate
end



