USE [CRMDB]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateUserProfile]    Script Date: 2016-07-02 8:27:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[spUpdateUserProfile]
	@UID bigint,
	@Username varchar(200),
	@Password varchar(50),
	@FirstName varchar(100),
	@LastName varchar(100),
	@DateModifed datetime,
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
	ClientName = @CompanyName,
	DateModified=GETDATE()
	Where CompanyId=@CompanyId
	
end