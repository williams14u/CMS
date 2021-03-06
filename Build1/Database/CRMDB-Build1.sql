USE [CRMDB]
GO
/****** Object:  StoredProcedure [dbo].[IsDeactivateUser]    Script Date: 7/9/2016 2:33:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsDeactivateUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[IsDeactivateUser]
@UID bigint
as 
begin
	delete from Userprofiles where UID=@UID
end' 
END
GO
/****** Object:  StoredProcedure [dbo].[IsUserExits]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsUserExits]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[IsUserExits]
@Username varchar(200),
@Password varchar(50),
@Status bit out,
@UID bigint out
as
begin
   if exists(select 1 from Userprofiles where Username=@Username and Password=@Password )

   begin
   set @Status=1
   select @UID=UID from Userprofiles where Username=@Username
   end;
   else
   begin
   set @Status=0;
   end;

end
' 
END
GO
/****** Object:  StoredProcedure [dbo].[spActiveUser]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spActiveUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROC [dbo].[spActiveUser]
@guid Uniqueidentifier
as 
begin
Update UserProfiles set Status=2 where GUID=@guid
end' 
END
GO
/****** Object:  StoredProcedure [dbo].[spBindCompanies]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spBindCompanies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create proc [dbo].[spBindCompanies]
as 
begin
select CompanyId,CompanyName from Companies
end' 
END
GO
/****** Object:  StoredProcedure [dbo].[spBindComponents]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spBindComponents]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create proc [dbo].[spBindComponents]
as 
begin
select ComponentId,ComponentName from Components
end' 
END
GO
/****** Object:  StoredProcedure [dbo].[spBindproducts]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spBindproducts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create proc [dbo].[spBindproducts]
as 
begin
select ProductId,ProductName from Products
end' 
END
GO
/****** Object:  StoredProcedure [dbo].[spCreateCompany]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spCreateCompany]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create proc [dbo].[spCreateCompany]

@CompanyId bigint out,
@CompanyName	varchar,
@TicketStartNumber	bigint= 0,
@CreatedBy	bigint,
@CurrentTicketNumber bigint=0,
@Status	int=0
as
Begin
insert into Companies(CompanyName,TicketStartNumber,CreatedBy,CurrentTicketNumber,Status)
				values(@CompanyName,@TicketStartNumber,@CreatedBy,@CurrentTicketNumber,@Status)
				set @CompanyId=@@IDENTITY
end

' 
END
GO
/****** Object:  StoredProcedure [dbo].[spGetAllTickets]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetAllTickets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[spGetAllTickets]
as
begin

select TicketNo,CompanyName,ProductName,ComponentName,Version,Title,Name as Assignee, tickets.DateCreated,
rank() over(order by tickets.ticketid) as R
from Companies 
left join tickets on tickets.CompanyId=Companies.CompanyId
left join products  p on tickets.ProductId=p.ProductId
left join components c on tickets.ComponentId=c.componentid
left join TicketAssignees ta on tickets.TicketId=ta.TicketId
left join SupportMembers sm on ta.AssignedTo=sm.Id
end;' 
END
GO
/****** Object:  StoredProcedure [dbo].[spgetCompanies]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spgetCompanies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[spgetCompanies]
as 
begin
select CompanyId,CompanyName from Companies
end' 
END
GO
/****** Object:  StoredProcedure [dbo].[spGetProductInfo]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetProductInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[spGetProductInfo]
@ProductId bigint
as
begin

select p.ProductId,ProductName,Version,p.CompanyId
from Products p
inner join Companies c on c.CompanyId=p.CompanyId
inner join ProductVersions pv on pv.ProductId=p.ProductId
where p.ProductId=@ProductId
end;' 
END
GO
/****** Object:  StoredProcedure [dbo].[spGetProducts]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetProducts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[spGetProducts]
@startIndex bigint,
@EndIndex bigint,
@ProductName varchar(200)

 as
  begin
     select *from(
     select p.ProductId, ProductName,CompanyName,Version,rank() over (order by p.productId) as R
     from Products p
     inner join Companies c on p.CompanyId=c.CompanyId 
	 inner join ProductVersions PV on p.ProductId=pv.ProductId
     where ProductName like @ProductName +''%'') P where P.r between @startIndex and @EndIndex
 end;
' 
END
GO
/****** Object:  StoredProcedure [dbo].[spGetTickets]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetTickets]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create proc [dbo].[spGetTickets]
@CompanyName varchar(200),
@StartIndex bigint,
@EndIndex bigint
as
begin

select * from (
select TicketNo,CompanyName,ProductName,ComponentName,Version,Title,Name as Assignee, tickets.DateCreated,
rank() over(order by tickets.ticketid) as R
from Companies 
inner join tickets on tickets.CompanyId=Companies.CompanyId
inner join products  p on tickets.ProductId=p.ProductId
inner join components c on tickets.ComponentId=c.componentid
left join TicketAssignees ta on tickets.TicketId=ta.TicketId
left join SupportMembers sm on ta.AssignedTo=sm.Id
where CompanyName like @CompanyName+''%'') T where t.R between @StartIndex and @EndIndex;
end;' 
END
GO
/****** Object:  StoredProcedure [dbo].[spGetUserProfilebyId]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUserProfilebyId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[spGetUserProfilebyId]
@UID bigint 
AS
Begin
select Username,Password,Firstname,Lastname,c.CompanyName from Userprofiles up join Companies c on up.CompanyId=c.CompanyId where UID=@UID
End' 
END
GO
/****** Object:  StoredProcedure [dbo].[spGetUsers]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[spGetUsers]
(@StartIndex bigint,
@EndIndex  bigint)

as
begin

/*
	declare @TempTable as Table(Id bigint identity(1,1), UID bigint);

	insert into @TempTable
	select UID  from userprofiles;

	select * from @temptable t 
	inner join UserProfiles u
	on t.UID=u.UID
	
	
	where id between @startindex and @endindex

	-------
	*/
	--declare @Startindex int,@endindex int
	--set @Startindex=3
	--set @endindex=10

	select t.* from (select *, Rank() over (order by UID ) as SNO from userprofiles) t
	where SNO between @Startindex and @endindex





end;' 
END
GO
/****** Object:  StoredProcedure [dbo].[spInsertTicket]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spInsertTicket]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[spInsertTicket]
@TicketNo    numeric(18,0),
@Title       varchar(200),
@Description varchar(400),
@ComponentId	bigint,
@Version     varchar(50),
@ProductId   bigint,
@CompanyId    int,
@CreatedBy bigint
as
begin
     insert into Tickets(TicketNo,Title,Description,ComponentId,Version,ProductId,CompanyId,Status,DateCreated,CreatedBy)		   

	  values(@TicketNo,@Title,@Description,@ComponentId,@Version,@ProductId,@CompanyId,0,GETDATE(),@CreatedBy);
end' 
END
GO
/****** Object:  StoredProcedure [dbo].[spInsertUser]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spInsertUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[spInsertUser]
@Username varchar(200),
@Password varchar(50),
@FirstName varchar(100),
@LastName varchar(100),
@CreatedBy bigint,
@GUID uniqueidentifier,
@UserType int,
@Status int,
@CompanyId bigint
as
begin
     insert into Userprofiles (Username,Password,Firstname,Lastname,CreatedBy,GUID,UserType,Status,CompanyId) 	
	  values(@Username,@Password,@FirstName,@LastName,@CreatedBy,@GUID,@UserType,@Status,@CompanyId);
end' 
END
GO
/****** Object:  StoredProcedure [dbo].[spIsEmailIdExists]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spIsEmailIdExists]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[spIsEmailIdExists]

@EmailId varchar(200),

@Status bit out

As



Begin 

	if exists(select Username from Userprofiles where Username=@EmailId)
	begin

	set @Status=1

	 

	end;

	else

	begin

	  set @Status=0

	end;



End' 
END
GO
/****** Object:  StoredProcedure [dbo].[spRegisterUser]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spRegisterUser]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE proc [dbo].[spRegisterUser]
(@Username varchar(200),
@Password varchar(50),
@CompanyName varchar(200),
@Guid  uniqueidentifier out)
as

begin
declare @uid bigint
declare @CompanyId  bigint
	   set @Guid=newid()
		insert into userprofiles(Username, password,guid,CompanyId, CreatedBy, Usertype, Status)
		values (@Username, @Password,@guid,0,0,1,0);
		set @uid=@@identity
		

		insert into Companies(CompanyName,TicketStartNumber, CurrentTicketNumber, CreatedBy)
		values (@CompanyName,1,0, @uid);
		set @CompanyId=@@Identity

		update userprofiles set CompanyId=@CompanyId where uid=@uid





end;' 
END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateUserProfile]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spUpdateUserProfile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[spUpdateUserProfile]
	@UID bigint,
	@Username varchar(200),
	@Password varchar(50),
	@FirstName varchar(100),
	@LastName varchar(100),
	--@DateModifed datetime,
	@CompanyName varchar(200)
as 
begin 
	declare @CompanyId bigint
	Update Userprofiles set
	Username=@Username,
	Password=@Password,
	Firstname=@FirstName,
	Lastname=@LastName,
	Datemodified = GETDATE()
	where UID=@UID
	select @CompanyId=CompanyId from Userprofiles where UID=@UID
	  
	Update Companies set
	CompanyName = @CompanyName,
	DateModified=GETDATE()
	Where CompanyId=@CompanyId
	
end' 
END
GO
/****** Object:  Table [dbo].[Companies]    Script Date: 7/9/2016 2:33:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Companies]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Companies](
	[CompanyId] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](200) NOT NULL,
	[TicketStartNumber] [bigint] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateModified] [datetime] NULL,
	[CreatedBy] [bigint] NOT NULL,
	[CurrentTicketNumber] [bigint] NOT NULL,
	[Status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Components]    Script Date: 7/9/2016 2:33:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Components]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Components](
	[ComponentId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductId] [bigint] NOT NULL,
	[Status] [int] NOT NULL,
	[ComponentName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ComponentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Products]    Script Date: 7/9/2016 2:33:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Products]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Products](
	[ProductId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](200) NULL,
	[CompanyId] [bigint] NULL,
	[Status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductVersions]    Script Date: 7/9/2016 2:33:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductVersions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductVersions](
	[VersionId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [bigint] NOT NULL,
	[Version] [varchar](200) NOT NULL,
	[Status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StatusCodes]    Script Date: 7/9/2016 2:33:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusCodes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StatusCodes](
	[StatusId] [int] IDENTITY(1,1) NOT NULL,
	[StatusCode] [int] NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[StatusTypeId] [int] NOT NULL
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StatusTypes]    Script Date: 7/9/2016 2:33:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusTypes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StatusTypes](
	[StatusTypeId] [int] IDENTITY(1,1) NOT NULL,
	[StatusType] [varchar](100) NULL
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SupportMembers]    Script Date: 7/9/2016 2:33:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SupportMembers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SupportMembers](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[EmailId] [varchar](200) NOT NULL,
	[CompanyId] [bigint] NOT NULL,
	[BranchId] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
UNIQUE NONCLUSTERED 
(
	[EmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TicketAssignees]    Script Date: 7/9/2016 2:33:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TicketAssignees]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TicketAssignees](
	[TicketAssigneeId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[TicketId] [numeric](18, 0) NOT NULL,
	[AssignedTo] [bigint] NOT NULL,
	[IsPrimary] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateModified] [datetime] NULL,
	[CreatedBy] [bigint] NOT NULL
)
END
GO
/****** Object:  Table [dbo].[TicketAttachments]    Script Date: 7/9/2016 2:33:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TicketAttachments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TicketAttachments](
	[AttacmentId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Attachment] [varbinary](1) NOT NULL,
	[TicketId] [numeric](18, 0) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateModified] [datetime] NULL,
	[CreatedBy] [bigint] NOT NULL
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TicketAudit]    Script Date: 7/9/2016 2:33:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TicketAudit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TicketAudit](
	[Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[TicketId] [numeric](18, 0) NOT NULL,
	[Remarks] [varchar](200) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateModified] [datetime] NULL,
	[CreatedBy] [bigint] NOT NULL
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TicketComments]    Script Date: 7/9/2016 2:33:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TicketComments]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TicketComments](
	[CommentId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[TicketId] [numeric](18, 0) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateModified] [datetime] NULL,
	[CreatedBy] [bigint] NOT NULL
)
END
GO
/****** Object:  Table [dbo].[Tickets]    Script Date: 7/9/2016 2:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tickets]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Tickets](
	[TicketId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[TicketNo] [numeric](18, 0) NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[Description] [varchar](200) NULL,
	[ProductId] [bigint] NOT NULL,
	[ComponentId] [bigint] NULL,
	[Version] [varchar](50) NULL,
	[Status] [int] NOT NULL,
	[CompanyId] [bigint] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateModified] [datetime] NULL,
	[CreatedBy] [bigint] NOT NULL,
	[DateFixed] [datetime] NULL,
	[DateClosed] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TicketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Userprofiles]    Script Date: 7/9/2016 2:33:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Userprofiles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Userprofiles](
	[UID] [bigint] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](200) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Firstname] [varchar](200) NULL,
	[Lastname] [varchar](200) NULL,
	[Datemodified] [datetime] NULL,
	[CreatedBy] [bigint] NOT NULL,
	[GUID] [uniqueidentifier] NOT NULL,
	[UserType] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CompanyId] [bigint] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tickets]    Script Date: 7/9/2016 2:33:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tickets]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Tickets](
	[TicketId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[TicketNo] [numeric](18, 0) NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[Description] [varchar](200) NULL,
	[ProductId] [bigint] NOT NULL,
	[ComponentId] [bigint] NULL,
	[Version] [varchar](50) NULL,
	[Status] [int] NOT NULL,
	[CompanyId] [bigint] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateModified] [datetime] NULL,
	[CreatedBy] [bigint] NOT NULL,
	[DateFixed] [datetime] NULL,
	[DateClosed] [datetime] NULL
)
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Companies__Ticke__10216507]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Companies] ADD  DEFAULT ((1)) FOR [TicketStartNumber]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Companies__DateC__11158940]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Companies] ADD  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Companies__Curre__12FDD1B2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Companies] ADD  DEFAULT ((1)) FOR [CurrentTicketNumber]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Companies__Statu__13F1F5EB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Companies] ADD  DEFAULT ((0)) FOR [Status]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Component__Statu__2F9A1060]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Components] ADD  DEFAULT ((1)) FOR [Status]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Products__Status__1A9EF37A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((1)) FOR [Status]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__ProductVe__Statu__1E6F845E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ProductVersions] ADD  DEFAULT ((1)) FOR [Status]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__TicketAss__DateC__3DE82FB7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TicketAssignees] ADD  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__TicketAtt__DateC__41B8C09B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TicketAttachments] ADD  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__TicketAud__DateC__29E1370A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TicketAudit] ADD  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__TicketCom__DateC__477199F1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TicketComments] ADD  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Tickets__DateCre__39237A9A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Tickets] ADD  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Userprofi__Creat__3864608B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Userprofiles] ADD  DEFAULT ((0)) FOR [CreatedBy]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Userprofi__UserT__395884C4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Userprofiles] ADD  DEFAULT ((1)) FOR [UserType]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Userprofi__Statu__3A4CA8FD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Userprofiles] ADD  DEFAULT ((0)) FOR [Status]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Userprofi__DateC__3B40CD36]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Userprofiles] ADD  DEFAULT (getdate()) FOR [DateCreated]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Companies__Creat__1209AD79]') AND parent_object_id = OBJECT_ID(N'[dbo].[Companies]'))
ALTER TABLE [dbo].[Companies]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Userprofiles] ([UID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Component__Produ__2EA5EC27]') AND parent_object_id = OBJECT_ID(N'[dbo].[Components]'))
ALTER TABLE [dbo].[Components]  WITH CHECK ADD FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Products__Compan__19AACF41]') AND parent_object_id = OBJECT_ID(N'[dbo].[Products]'))
ALTER TABLE [dbo].[Products]  WITH CHECK ADD FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Companies] ([CompanyId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__ProductVe__Produ__1D7B6025]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductVersions]'))
ALTER TABLE [dbo].[ProductVersions]  WITH CHECK ADD FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__SupportMe__Compa__24285DB4]') AND parent_object_id = OBJECT_ID(N'[dbo].[SupportMembers]'))
ALTER TABLE [dbo].[SupportMembers]  WITH CHECK ADD FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Companies] ([CompanyId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TicketAss__Assig__3CF40B7E]') AND parent_object_id = OBJECT_ID(N'[dbo].[TicketAssignees]'))
ALTER TABLE [dbo].[TicketAssignees]  WITH CHECK ADD FOREIGN KEY([AssignedTo])
REFERENCES [dbo].[SupportMembers] ([Id])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TicketAss__Creat__3EDC53F0]') AND parent_object_id = OBJECT_ID(N'[dbo].[TicketAssignees]'))
ALTER TABLE [dbo].[TicketAssignees]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Userprofiles] ([UID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TicketAss__Ticke__3BFFE745]') AND parent_object_id = OBJECT_ID(N'[dbo].[TicketAssignees]'))
ALTER TABLE [dbo].[TicketAssignees]  WITH CHECK ADD FOREIGN KEY([TicketId])
REFERENCES [dbo].[Tickets] ([TicketId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TicketAtt__Creat__42ACE4D4]') AND parent_object_id = OBJECT_ID(N'[dbo].[TicketAttachments]'))
ALTER TABLE [dbo].[TicketAttachments]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Userprofiles] ([UID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TicketAtt__Ticke__40C49C62]') AND parent_object_id = OBJECT_ID(N'[dbo].[TicketAttachments]'))
ALTER TABLE [dbo].[TicketAttachments]  WITH CHECK ADD FOREIGN KEY([TicketId])
REFERENCES [dbo].[Tickets] ([TicketId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TicketCom__Creat__4865BE2A]') AND parent_object_id = OBJECT_ID(N'[dbo].[TicketComments]'))
ALTER TABLE [dbo].[TicketComments]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Userprofiles] ([UID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__TicketCom__Ticke__467D75B8]') AND parent_object_id = OBJECT_ID(N'[dbo].[TicketComments]'))
ALTER TABLE [dbo].[TicketComments]  WITH CHECK ADD FOREIGN KEY([TicketId])
REFERENCES [dbo].[Tickets] ([TicketId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Tickets__Company__382F5661]') AND parent_object_id = OBJECT_ID(N'[dbo].[Tickets]'))
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Companies] ([CompanyId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Tickets__Compone__373B3228]') AND parent_object_id = OBJECT_ID(N'[dbo].[Tickets]'))
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD FOREIGN KEY([ComponentId])
REFERENCES [dbo].[Components] ([ComponentId])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Tickets__Created__3A179ED3]') AND parent_object_id = OBJECT_ID(N'[dbo].[Tickets]'))
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Userprofiles] ([UID])
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK__Tickets__Product__36470DEF]') AND parent_object_id = OBJECT_ID(N'[dbo].[Tickets]'))
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
