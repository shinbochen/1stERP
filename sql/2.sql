if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_table_return_order_list_table_return_order_head]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[table_return_order_list] DROP CONSTRAINT FK_table_return_order_list_table_return_order_head
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[table_return_order_head]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[table_return_order_head]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[table_return_order_list]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[table_return_order_list]
GO

CREATE TABLE [dbo].[table_return_order_head] (
	[troh_id] [int] NOT NULL ,
	[troh_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[troh_time] [smalldatetime] NOT NULL ,
	[tc_shortname] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[ts_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[troh_remark] [varchar] (500) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[table_return_order_list] (
	[trol_id] [int] IDENTITY (1, 1) NOT NULL ,
	[troh_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tp_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[tsi_no] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[trol_amount] [int] NOT NULL 
) ON [PRIMARY]
GO

