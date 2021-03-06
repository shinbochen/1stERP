CREATE TABLE [dbo].[table_stock_bf_head] (
	[tsbh_id] [int] IDENTITY (1, 1) NOT NULL ,
	[tsbh_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tsbh_time] [smalldatetime] NOT NULL ,
	[tsi_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[ts_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tsbh_remark] [varchar] (500) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[table_stock_bf_list] (
	[tsbl_id] [int] IDENTITY (1, 1) NOT NULL ,
	[tsbh_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tp_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tsbl_amount] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[table_stock_bf_head] WITH NOCHECK ADD 
	CONSTRAINT [PK_table_stock_bf_head] PRIMARY KEY  CLUSTERED 
	(
		[tsbh_no]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[table_stock_bf_list] WITH NOCHECK ADD 
	CONSTRAINT [PK_table_stock_bf_list] PRIMARY KEY  CLUSTERED 
	(
		[tsbh_no],
		[tp_no]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[table_stock_bf_list] ADD 
	CONSTRAINT [DF_table_stock_bf_list_tsbl_mount] DEFAULT (0) FOR [tsbl_amount]
GO

ALTER TABLE [dbo].[table_stock_bf_head] ADD 
	CONSTRAINT [FK_table_stock_bf_head_table_staff] FOREIGN KEY 
	(
		[ts_no]
	) REFERENCES [dbo].[table_staff] (
		[ts_no]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_table_stock_bf_head_table_stock_info] FOREIGN KEY 
	(
		[tsi_no]
	) REFERENCES [dbo].[table_stock_information] (
		[tsi_no]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

ALTER TABLE [dbo].[table_stock_bf_list] ADD 
	CONSTRAINT [FK_table_stock_bf_list_table_product] FOREIGN KEY 
	(
		[tp_no]
	) REFERENCES [dbo].[table_product] (
		[tp_no]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_table_stock_bf_list_table_stock_bf_head] FOREIGN KEY 
	(
		[tsbh_no]
	) REFERENCES [dbo].[table_stock_bf_head] (
		[tsbh_no]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE pro_AddBFOrderHead
		  	@tsbh_id		varchar(4),	
			@tsbh_no		varchar(20),
			@tsbh_time		varchar(20),			
			@tsi_no			varchar(20),		
			@ts_no			varchar(20),				
			@tsbh_remark		varchar(500)				
 AS

SET NOCOUNT ON

declare @cnt 	int
select @cnt = count(*) from table_stock_bf_head where tsbh_no = @tsbh_no
if (@cnt > 0)
	begin
		select MSG = 0

	end
else
	begin
		insert into table_stock_bf_head( 
					tsbh_no,
					tsbh_time,			
					tsi_no,		
					ts_no,				
					tsbh_remark)	
				values(			
					@tsbh_no,
					@tsbh_time,			
					@tsi_no,		
					@ts_no,				
					@tsbh_remark )		
		select MSG = 1
				
	end

SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE pro_AddBFOrderList
		  	@tsbl_id			varchar(4),	
				@tsbh_no		varchar(20),
				@tp_no			varchar(20),			
				@tsbl_amount		varchar(20)			
AS

SET NOCOUNT ON



declare 	@cnt 		int
declare 	@amount 	int
declare		@tsi_no		varchar(20)
declare		@today		smalldatetime

set				@today = getdate()

select 	@cnt = count(*) from table_stock_bf_list where tsbh_no = @tsbh_no and tp_no=@tp_no
select 	@tsi_no = tsi_no from table_stock_bf_head where tsbh_no = @tsbh_no


if (@cnt > 0 )
	begin
		select MSG = 0
	end
else
	begin
		insert into table_stock_bf_list( 
					tsbh_no,
					tp_no,			
					tsbl_amount)	
				values(			
					@tsbh_no,
					@tp_no,			
					@tsbl_amount )				
			

		insert into	table_stock_bill(
				tsb_time,
				tsi_no,
				tp_no,
				tsb_amount,
				tsb_ref_no
		)
		values(
				@today,
				@tsi_no,
				@tp_no,
				0 - convert(int,@tsbl_amount),
				@tsbh_no + ' add'
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


CREATE PROCEDURE pro_DeleteBFOrderHead
		  	@tsbh_id		varchar(4),	
			@tsbh_no		varchar(20),
			@tsbh_time		varchar(20),			
			@tsi_no			varchar(20),		
			@ts_no			varchar(20),				
			@tsbh_remark		varchar(500)				
 AS

SET NOCOUNT ON

declare @cnt 	int
select @cnt = count(*) from table_stock_bf_head where tsbh_no = @tsbh_no
if (@cnt > 0)
	begin
		
		delete table_stock_bf_head
		where tsbh_no = @tsbh_no
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

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE pro_DeleteBFOrderList
		  	@tsbl_id			varchar(4),	
				@tsbh_no		varchar(20),
				@tp_no			varchar(20),			
				@tsbl_amount		varchar(20)				
AS

SET NOCOUNT ON

declare 	@cnt 		int
declare 	@amount 	int
declare		@tsi_no		varchar(20)
declare		@today		smalldatetime

set				@today = getdate()

select 	@cnt = count(*) 
from table_stock_bf_list 
where tsbh_no = @tsbh_no and tp_no=@tp_no

select 	@tsi_no = tsi_no 
from 		table_stock_bf_head 
where 	tsbh_no = @tsbh_no

if (@cnt > 0 )
	begin
		select 	@amount = tsbl_amount 
		from table_stock_bf_list 
		where tsbh_no = @tsbh_no and tp_no=@tp_no
		
		delete table_stock_bf_list 
		where	 tsbh_no = @tsbh_no and tp_no=@tp_no
			
		insert into	table_stock_bill(
				tsb_time,
				tsi_no,
				tp_no,
				tsb_amount,
				tsb_ref_no
		)
		values(
				@today,
				@tsi_no,
				@tp_no,
				@amount,
				@tsbh_no + ' delete'
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


CREATE PROCEDURE pro_ModifyBFOrderHead
		  	@tsbh_id		varchar(4),	
			@tsbh_no		varchar(20),
			@tsbh_time		varchar(20),			
			@tsi_no			varchar(20),		
			@ts_no			varchar(20),				
			@tsbh_remark		varchar(500)				
 AS

SET NOCOUNT ON

declare @cnt 	int
select @cnt = count(*) from table_stock_bf_head where tsbh_no = @tsbh_no
if (@cnt > 0)
	begin
		
		update table_stock_bf_head set
					tsbh_no =@tsbh_no,
					tsbh_time=@tsbh_time,		
					tsi_no=@tsi_no,		
					ts_no=@ts_no,			
					tsbh_remark=@tsbh_remark
		where tsbh_no = @tsbh_no
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

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


CREATE PROCEDURE pro_ModifyBFOrderList
		  	@tsbl_id			varchar(4),	
			@tsbh_no		varchar(20),
			@tp_no			varchar(20),			
			@tsbl_amount		varchar(20)				
AS

SET NOCOUNT ON

declare 	@cnt 		int
declare 	@amount 	int
declare	@tsi_no		varchar(20)
declare	@today		smalldatetime

set				@today = getdate()

select 	@cnt = count(*) from table_stock_bf_list where tsbh_no = @tsbh_no and tp_no=@tp_no
select 	@tsi_no = tsi_no from table_stock_bf_head where tsbh_no = @tsbh_no

if (@cnt > 0 )
	begin
		select 	@amount = tsbl_amount from table_stock_bf_list where tsbh_no = @tsbh_no and tp_no=@tp_no
		
		update table_stock_bf_list set 				
					tsbh_no = @tsbh_no,
					tp_no = @tp_no,		
					tsbl_amount = @tsbl_amount
		where	 tsbh_no = @tsbh_no and tp_no=@tp_no

		
		insert into	table_stock_bill(
				tsb_time,
				tsi_no,
				tp_no,
				tsb_amount,
				tsb_ref_no
		)
		values(
				@today,
				@tsi_no,
				@tp_no,
				@amount,
				@tsbh_no + ' modify'
		)


		insert into	table_stock_bill(
				tsb_time,
				tsi_no,
				tp_no,
				tsb_amount,
				tsb_ref_no
		)
		values(
				@today,
				@tsi_no,
				@tp_no,
				0 - convert(int,@tsbl_amount),
				@tsbh_no + ' modify'
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

