USE [CRMDB]
GO
/****** Object:  StoredProcedure [dbo].[IsUserExits]    Script Date: 2016-07-06 9:10:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[IsUserExits]
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
   set @UID=0
   end;

end
