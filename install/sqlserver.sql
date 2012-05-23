/****** Object:  Table [dbo].[ads]    Script Date: 1/24/2006 9:38:26 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ads]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ads]
GO

/****** Object:  Table [dbo].[ads_clicks]    Script Date: 1/24/2006 9:38:26 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ads_clicks]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ads_clicks]
GO

/****** Object:  Table [dbo].[ads_impressions]    Script Date: 1/24/2006 9:38:26 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ads_impressions]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ads_impressions]
GO

/****** Object:  Table [dbo].[campaigns]    Script Date: 1/24/2006 9:38:26 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[campaigns]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[campaigns]
GO

/****** Object:  Table [dbo].[campaigns_ads]    Script Date: 1/24/2006 9:38:26 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[campaigns_ads]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[campaigns_ads]
GO

/****** Object:  Table [dbo].[clients]    Script Date: 1/24/2006 9:38:26 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[clients]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[clients]
GO

/****** Object:  Table [dbo].[groups]    Script Date: 1/24/2006 9:38:26 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[groups]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[groups]
GO

/****** Object:  Table [dbo].[users]    Script Date: 1/24/2006 9:38:26 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[users]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[users]
GO

/****** Object:  Table [dbo].[users_groups]    Script Date: 1/24/2006 9:38:26 PM ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[users_groups]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[users_groups]
GO

/****** Object:  Table [dbo].[ads]    Script Date: 1/24/2006 9:38:26 PM ******/
CREATE TABLE [dbo].[ads] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[clientidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[height] [int] NULL ,
	[width] [int] NULL ,
	[title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[body] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[url] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[active] [bit] NOT NULL ,
	[created] [datetime] NOT NULL ,
	[updated] [datetime] NOT NULL ,
	[target] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[html] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ads_clicks]    Script Date: 1/24/2006 9:38:27 PM ******/
CREATE TABLE [dbo].[ads_clicks] (
	[thetime] [datetime] NOT NULL ,
	[adidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[campaignidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[ads_impressions]    Script Date: 1/24/2006 9:38:27 PM ******/
CREATE TABLE [dbo].[ads_impressions] (
	[thetime] [datetime] NOT NULL ,
	[adidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[campaignidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[campaigns]    Script Date: 1/24/2006 9:38:27 PM ******/
CREATE TABLE [dbo].[campaigns] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[created] [datetime] NOT NULL ,
	[updated] [datetime] NOT NULL ,
	[active] [bit] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[campaigns_ads]    Script Date: 1/24/2006 9:38:27 PM ******/
CREATE TABLE [dbo].[campaigns_ads] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[campaignidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[adidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[weight] [int] NOT NULL ,
	[datebegin] [datetime] NULL ,
	[dateend] [datetime] NULL ,
	[timebegin] [datetime] NULL ,
	[timeend] [datetime] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[clients]    Script Date: 1/24/2006 9:38:27 PM ******/
CREATE TABLE [dbo].[clients] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[emailaddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[notes] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[groups]    Script Date: 1/24/2006 9:38:27 PM ******/
CREATE TABLE [dbo].[groups] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[users]    Script Date: 1/24/2006 9:38:27 PM ******/
CREATE TABLE [dbo].[users] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[username] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[password] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[emailaddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[users_groups]    Script Date: 1/24/2006 9:38:27 PM ******/
CREATE TABLE [dbo].[users_groups] (
	[useridfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[groupidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ads] WITH NOCHECK ADD 
	CONSTRAINT [PK_ads] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[campaigns] WITH NOCHECK ADD 
	CONSTRAINT [PK_campaigns] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[campaigns_ads] WITH NOCHECK ADD 
	CONSTRAINT [PK_campaigns_ads] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[clients] WITH NOCHECK ADD 
	CONSTRAINT [PK_clients] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[groups] WITH NOCHECK ADD 
	CONSTRAINT [PK_groups] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[users] WITH NOCHECK ADD 
	CONSTRAINT [PK_users] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

INSERT INTO groups(id, name) VALUES ('99C5AACE-92B3-7D72-6E5B4017FD38ACED','admin');

INSERT INTO users(id, name, emailaddress, username, password) VALUES ('94CC6A2B-A60E-187D-5BFEA49A0FB60145','Raymond Camden','ray@camdenfamily.com','admin','password');

INSERT INTO users_groups(useridfk, groupidfk) VALUES ('94CC6A2B-A60E-187D-5BFEA49A0FB60145','99C5AACE-92B3-7D72-6E5B4017FD38ACED');
