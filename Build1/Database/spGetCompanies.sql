
/****** Object:  StoredProcedure [dbo].[spGetCompanies]    Script Date: 7/7/2016 11:04:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[spGetCompanies]
as
begin
select CompanyId,CompanyName from Companies
end;