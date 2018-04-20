CREATE function func_getSalesOrderRecvMoneySummary ( 
			@tsoh_no   	varchar(20)
			)
returns	float
as
begin
	declare		@all_money		float

	
	select 	@all_money = sum( tsel_money)
	from	table_sales_earning_list where tsoh_no = @tsoh_no


	return @all_money
end

