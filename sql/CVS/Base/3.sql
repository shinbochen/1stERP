CREATE TABLE [dbo].[table_purchase_input_head] (
	[tpih_id] [int] IDENTITY (1, 1) NOT NULL ,
	[tpih_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tpih_time] [smalldatetime] NOT NULL ,
	[ts_shortname] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tsi_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[ts_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tpih_remark] [varchar] (500) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[table_purchase_input_list] (
	[tpil_id] [int] IDENTITY (1, 1) NOT NULL ,
	[tpih_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tpoh_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tp_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tpil_amount] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[table_purchase_input_head] WITH NOCHECK ADD 
	CONSTRAINT [PK_table_purchase_input_head] PRIMARY KEY  CLUSTERED 
	(
		[tpih_no]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[table_purchase_input_list] WITH NOCHECK ADD 
	CONSTRAINT [PK_table_purchase_input_list] PRIMARY KEY  CLUSTERED 
	(
		[tpih_no],
		[tpoh_no],
		[tp_no]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[table_purchase_input_head] ADD 
	CONSTRAINT [FK_table_purchase_input_head_table_supplier] FOREIGN KEY 
	(
		[ts_shortname]
	) REFERENCES [dbo].[table_supplier] (
		[ts_shortname]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_table_purchase_input_head_table_staff] FOREIGN KEY 
	(
		[ts_no]
	) REFERENCES [dbo].[table_staff] (
		[ts_no]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_table_purchase_input_head_table_stock_info] FOREIGN KEY 
	(
		[tsi_no]
	) REFERENCES [dbo].[table_stock_information] (
		[tsi_no]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

ALTER TABLE [dbo].[table_purchase_input_list] ADD 
	CONSTRAINT [FK_table_purchase_input_list_table_product] FOREIGN KEY 
	(
		[tp_no]
	) REFERENCES [dbo].[table_product] (
		[tp_no]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_table_purchase_input_list_table_purchase_input_head] FOREIGN KEY 
	(
		[tpih_no]
	) REFERENCES [dbo].[table_purchase_input_head] (
		[tpih_no]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE pro_AddPurchaseInputHead
		  	@tpih_id		varchar(4),	
				@tpih_no		varchar(20),
				@tpih_time		varchar(20),			
				@ts_shortname		varchar(20),		
				@tsi_no		varchar(20),		
				@ts_no			varchar(20),				
				@tpih_remark		varchar(500)				
 AS

SET NOCOUNT ON

declare @cnt 	int
select @cnt = count(*) from table_purchase_input_head where tpih_no = @tpih_no
if (@cnt > 0)
	begin
		select MSG = 0

	end
else
	begin
		insert into table_purchase_input_head( 
					tpih_no,
					tpih_time,			
					ts_shortname,	
					tsi_no,
					ts_no,		
					tpih_remark)	
				values(					
					@tpih_no,
					@tpih_time,			
					@ts_shortname,		
					@tsi_no,
					@ts_no,				
					@tpih_remark )		
		select MSG = 1
				
	end

SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE 	pro_AddPurchaseInputList
		  	@tpil_id		varchar(4),	
			@tpih_no		varchar(20),
			@tpoh_no		varchar(20),
			@tp_no			varchar(20),			
			@tpil_amount		varchar(20)			
 AS

SET NOCOUNT ON

declare @cnt 		int
declare @amount	int
declare	@tsi_no		varchar(20)
declare	@today		smalldatetime


select @cnt = count(*) 
from table_purchase_input_list 
where tpih_no = @tpih_no and tpoh_no = @tpoh_no and tp_no = @tp_no

select @today=getdate();

if (@cnt > 0)
	begin
		select MSG = 0
	end
else
	begin
		select 	@tsi_no = tsi_no
		from	table_purchase_input_head
		where	tpih_no =  @tpih_no

		set	@amount = convert( int,  @tpil_amount)

		insert into table_purchase_input_list( 
					tpih_no,
					tpoh_no,
					tp_no,
					tpil_amount)	
				values(			
					@tpih_no,
					@tpoh_no,			
					@tp_no,				
					@tpil_amount )		
		
		insert into table_stock_bill(					
					tsb_time,
					tsi_no,
					tp_no,
					tsb_ref_no,
					tsb_amount
					)
				values(
					@today,
					@tsi_no,
					@tp_no,
					@tpih_no,
					@amount				
					)
		select MSG = 1
				
	end

SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE 	pro_DeletePurchaseInputList
		  	@tpil_id		varchar(4),	
			@tpih_no		varchar(20),
			@tpoh_no		varchar(20),
			@tp_no			varchar(20),			
			@tpil_amount		varchar(20)			
 AS

SET NOCOUNT ON

declare @cnt 		int
declare @amount	int
declare	@tsi_no		varchar(20)
declare	@today		smalldatetime


select @cnt = count(*) 
from table_purchase_input_list 
where tpih_no = @tpih_no and tpoh_no = @tpoh_no and tp_no = @tp_no

select @today=getdate();

if (@cnt > 0)
	begin
		select 	@tsi_no = tsi_no
		from	table_purchase_input_head
		where	tpih_no =  @tpih_no
		
		select @amount = 0-tpil_amount
		from table_purchase_input_list
		where tpih_no = @tpih_no and tpoh_no = @tpoh_no and tp_no = @tp_no

		delete table_purchase_input_list
		where tpih_no = @tpih_no and tpoh_no = @tpoh_no and tp_no = @tp_no
		
		insert into table_stock_bill(
					tsb_time,
					tsi_no,
					tp_no,
					tsb_ref_no,
					tsb_amount
					)
				values(
					@today,
					@tsi_no,
					@tp_no,
					@tpih_no,
					@amount				
					)
		select MSG = 1
	end
else
	begin		
		select MSG = 0
				
	end

SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE pro_ModifyPurchaseInputHead
		  	@tpih_id		varchar(4),	
			@tpih_no		varchar(20),
			@tpih_time		varchar(20),			
			@ts_shortname		varchar(20),		
			@tsi_no		varchar(20),		
			@ts_no			varchar(20),				
			@tpih_remark		varchar(500)				
 AS

SET NOCOUNT ON

declare @cnt 	int
select @cnt = count(*) from table_purchase_input_head where tpih_no = @tpih_no
if (@cnt > 0)
	begin
		
		update table_purchase_input_head set
					tpih_no =@tpih_no,
					tpih_time=@tpih_time,			
					ts_shortname=@ts_shortname,
					tsi_no=@tsi_no,
					ts_no=@ts_no,	
					tpih_remark=@tpih_remark
		where tpih_no = @tpih_no
		select MSG = 1

	end
else
	begin
		select MSG = 0
				
	end
SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

