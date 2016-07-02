USE [CRMDB]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserProfilebyId]    Script Date: 2016-07-02 10:00:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[spGetUserProfilebyId]
@UID bigint 
AS
Begin
select Username,Password,c.ClientName from Userprofiles up join Companies c on up.CompanyId=c.CompanyId where UID=@UID
End